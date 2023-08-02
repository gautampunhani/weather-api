# frozen_string_literal: true

require 'rails_helper'

describe LocationWeather do
  describe 'current_weather' do
    it 'should give me current weather based on latest recorded in last 12 hours' do
      create(:location_weather, forecast_for: Time.now - 2.hour, temperature: 35)
      create(:location_weather, forecast_for: Time.now - 3.hour, temperature: 42)
      location_weather = create(:location_weather, forecast_for: Time.now - 1.hour, temperature: 23)
      create(:location_weather, forecast_for: Time.now + 1.hour, temperature: 45)

      current_weather = LocationWeather.current_weather(location_weather.zipcode)

      expect(current_weather).to eql(location_weather)
    end

    it 'should give empty result if no records within last 12 hours were found' do
      location_weather = create(:location_weather, forecast_for: Time.now - 14.hours, temperature: 11)
      current_weather = LocationWeather.current_weather(location_weather.zipcode)

      expect(current_weather).to be_nil
    end
  end

  describe 'aggregate_weather_stats' do
    it 'should aggregate individual forecast for a given day' do
      location_weather = create(:location_weather, forecast_for: '2023-08-02 12:00:00 +0530', temperature: 35,
                                                   humidity: 23, wind_speed: 13)
      create(:location_weather, forecast_for: '2023-08-02 15:00:00 +0530', temperature: 42, humidity: 17,
                                wind_speed: 17)
      create(:location_weather, forecast_for: '2023-08-03 12:00:00 +0530', temperature: 34, humidity: 11,
                                wind_speed: 23)

      aggregated_results = LocationWeather.aggregate_weather_by_date(location_weather.zipcode,
                                                                     Time.now.beginning_of_day, Time.now + 3.days)
      expect(aggregated_results.length).to eql(2)
      expect(aggregated_results[0]).to eql({ 'date' => Time.now.to_date.strftime('%Y-%m-%d'),
                                             'high_temperature' => 42.0, 'humidity' => 20.0, 'low_temperature' => 35.0, 'wind_speed' => 15.0, 'zipcode' => '13271' })
      expect(aggregated_results[1]).to eql({ 'date' => 1.day.from_now.to_date.strftime('%Y-%m-%d'),
                                             'high_temperature' => 34.0, 'humidity' => 11.0, 'low_temperature' => 34.0, 'wind_speed' => 23.0, 'zipcode' => '13271' })
    end

    it 'should return empty if no data found' do
      location_weather = create(:location_weather, forecast_for: 4.days.from_now, temperature: 34, humidity: 11,
                                                   wind_speed: 23)
      aggregated_results = LocationWeather.aggregate_weather_by_date(location_weather.zipcode,
                                                                     Time.now.beginning_of_day, Time.now + 3.days)
      expect(aggregated_results.length).to eql(0)
    end
  end

  describe 'as json' do
    it 'should exclude id, created_at and updated_at fields' do
      location_weather = create(:location_weather)
      result = location_weather.as_json
      unwanted_columns = %i[id created_at updated_at]
      res = result.keys.filter { |key| unwanted_columns.include? key }
      expect(res).to be_empty
    end
  end
end
