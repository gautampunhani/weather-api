# frozen_string_literal: true

require 'rails_helper'

describe 'WeatherForecastService' do
  before(:each) do
    @location_weather = create(:location_weather)
  end

  describe 'current_forecast' do
    describe 'without cache' do
      it 'should return current weather of the given city' do
        # other_city_weather also created
        create(:location_weather, zipcode: '13281', temperature: 53)

        returned_forecast = WeatherForecastService.current_forecast(@location_weather.zipcode)
        expect(returned_forecast[:current]).to eql(@location_weather.as_json)
      end

      it 'should return weather report for current date' do
        create(:location_weather, temperature: 67)

        returned_forecast = WeatherForecastService.current_forecast(@location_weather.zipcode)
        expect(returned_forecast[:day_summary].to_json).to eql(build(:weather_report, high_temperature: 67.0,
                                                                                      low_temperature: 37.8, humidity: 21.0, wind_speed: 12.0).to_json)
      end

      it 'should return the latest weather report created for the given city' do
        travel 5.seconds do
          location_weather_latest = create(:location_weather, zipcode: '13271', temperature: 78)

          returned_forecast = WeatherForecastService.current_forecast(@location_weather.zipcode)
          expect(returned_forecast[:current]).to eql(location_weather_latest.as_json)
        end
      end

      it 'should return blank result if no result found' do
        returned_forecast = WeatherForecastService.current_forecast('14271')

        expect(returned_forecast[:current]).to be_nil
        expect(returned_forecast[:day_summary]).to be_nil
      end
    end

    describe 'with cache' do
      let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
      let(:cache) { Rails.cache }

      before do
        allow(Rails).to receive(:cache).and_return(memory_store)
        Rails.cache.clear
      end

      it 'should return cache flag as false if location weather not found in cache' do
        returned_forecast = WeatherForecastService.current_forecast(@location_weather.zipcode)
        expect(returned_forecast[:cached]).to be_falsey
      end

      it 'should fetch the object from cache on subsequent requests within 30 minutes' do
        returned_forecast = WeatherForecastService.current_forecast(@location_weather.zipcode)
        expect(returned_forecast[:cached]).to be_falsey

        returned_forecast = WeatherForecastService.current_forecast(@location_weather.zipcode)
        expect(returned_forecast[:cached]).to be_truthy
      end

      it 'should fetch object from database if record is invalidated' do
        WeatherForecastService.current_forecast(@location_weather.zipcode)
        returned_forecast = WeatherForecastService.current_forecast(@location_weather.zipcode)
        expect(returned_forecast[:cached]).to be_truthy

        LocationWeatherObserver.instance.after_save(@location_weather)

        returned_forecast = WeatherForecastService.current_forecast(@location_weather.zipcode)
        expect(returned_forecast[:cached]).to be_falsey
      end

      it 'should fetch from database after 30 minutes instead of cache' do
        WeatherForecastService.current_forecast(@location_weather.zipcode)
        returned_forecast = WeatherForecastService.current_forecast(@location_weather.zipcode)
        expect(returned_forecast[:cached]).to be_truthy

        travel 35.minutes do
          returned_forecast = WeatherForecastService.current_forecast(@location_weather.zipcode)
          expect(returned_forecast[:cached]).to be_falsey
        end
      end
    end
  end

  describe 'extended_forecast' do
    describe 'without cache' do
      it 'should return extended weather forecast of the given city' do
        # other_city_weather also created
        15.times.each { |i| create(:location_weather, forecast_for: i.days.from_now) }

        returned_forecast = WeatherForecastService.extended_forecast(@location_weather.zipcode)
        expect(returned_forecast.to_json).to eql(create(:extended_forecast).to_json)
      end

      it 'should return blank result if no result found' do
        returned_forecast = WeatherForecastService.extended_forecast('14271')

        expect(returned_forecast[:daily_extended_forecast]).to be_empty
      end
    end

    describe 'with cache' do
      let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
      let(:cache) { Rails.cache }

      before do
        allow(Rails).to receive(:cache).and_return(memory_store)
        Rails.cache.clear
      end

      it 'should return cache flag as false if location weather not found in cache' do
        returned_forecast = WeatherForecastService.extended_forecast(@location_weather.zipcode)
        expect(returned_forecast[:cached]).to be_falsey
      end

      it 'should fetch the object from cache on subsequent requests within 30 minutes' do
        returned_forecast = WeatherForecastService.extended_forecast(@location_weather.zipcode)
        expect(returned_forecast[:cached]).to be_falsey

        returned_forecast = WeatherForecastService.extended_forecast(@location_weather.zipcode)
        expect(returned_forecast[:cached]).to be_truthy
      end

      it 'should fetch object from database if record is invalidated' do
        WeatherForecastService.extended_forecast(@location_weather.zipcode)
        returned_forecast = WeatherForecastService.extended_forecast(@location_weather.zipcode)
        expect(returned_forecast[:cached]).to be_truthy

        LocationWeatherObserver.instance.after_save(@location_weather)

        returned_forecast = WeatherForecastService.extended_forecast(@location_weather.zipcode)
        expect(returned_forecast[:cached]).to be_falsey
      end

      it 'should fetch from database after 30 minutes instead of cache' do
        WeatherForecastService.extended_forecast(@location_weather.zipcode)
        returned_forecast = WeatherForecastService.extended_forecast(@location_weather.zipcode)
        expect(returned_forecast[:cached]).to be_truthy

        travel 35.minutes do
          returned_forecast = WeatherForecastService.extended_forecast(@location_weather.zipcode)
          expect(returned_forecast[:cached]).to be_falsey
        end
      end
    end
  end
end
