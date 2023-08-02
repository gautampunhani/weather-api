# frozen_string_literal: true

require 'rails_helper'

describe WeatherForecastController do
  before(:each) do
    @location_weather = create(:location_weather)
  end

  describe 'extended forecast' do
    describe 'validate params' do
      it 'should return error json with bad request if zipcode is not passed' do
        message = 'Zipcode cannot be blank'
        get :extended_forecast, params: { "city": 'some_city', "zipcode": '' }
        received_response = JSON.parse(response.body, symoblize_names: true)
        # require 'pry'; binding.pry

        assert_response :bad_request
        expect(message).to eql(received_response['error'])
      end

      it 'should return error json with bad request if zipcode is not not valid' do
        message = 'Invalid zipcode format'
        get :extended_forecast, params: { "city": 'some_city', "zipcode": '565656' }
        received_response = JSON.parse(response.body, symoblize_names: true)

        assert_response :bad_request
        expect(message).to eql(received_response['error'])
      end
    end

    it 'should return weather of the given city' do
      allow(WeatherForecastService).to receive(:extended_forecast).and_return({ daily_extended_forecast: ['something'] })
      # other_city_weather also created
      create(:location_weather, zipcode: '13281', temperature: 53)

      get :extended_forecast, params: { "city": 'some_city', "zipcode": '13271' }

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      expect(received_response).to eq({ 'daily_extended_forecast' => ['something'] })
    end

    it "should return error if zipcode doesn't exist" do
      allow(WeatherForecastService).to receive(:extended_forecast).and_return({ daily_extended_forecast: [] })

      zipcode = '13271'
      get :extended_forecast, params: { "city": 'some_city', "zipcode": zipcode }
      received_response = JSON.parse(response.body, symoblize_names: true)

      assert_response :not_found
      expect(received_response['error']).to eql("Extended weather forecast not found for #{zipcode}")
    end
  end

  describe 'daily forecast' do
    describe 'validate params' do
      it 'should return error json with bad request if zipcode is not passed' do
        message = 'Zipcode cannot be blank'
        get :daily_forecast, params: { "city": 'some_city', "zipcode": '' }
        received_response = JSON.parse(response.body, symoblize_names: true)
        # require 'pry'; binding.pry

        assert_response :bad_request
        expect(message).to eql(received_response['error'])
      end

      it 'should return error json with bad request if zipcode is not not valid' do
        message = 'Invalid zipcode format'
        get :daily_forecast, params: { "city": 'some_city', "zipcode": '565656' }
        received_response = JSON.parse(response.body, symoblize_names: true)

        assert_response :bad_request
        expect(message).to eql(received_response['error'])
      end
    end

    it 'should return weather of the given city' do
      # other_city_weather also created
      create(:location_weather, zipcode: '13281', temperature: 53)

      get :daily_forecast, params: { "city": 'some_city', "zipcode": '13271' }

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      columns = %i[zipcode temperature city high_temperature low_temperature wind_speed air_quality
                   air_pressure humidity]
      columns.each do |field|
        expect(received_response['current'][field.to_s]).to eql(@location_weather[field])
      end

      expect(received_response['current'].keys.filter do |key|
               !(columns.include?(key.to_sym) || key.to_sym === :forecast_for)
             end).to be_empty
    end

    it 'should return error if no results found' do
      zipcode = '14271'
      get :daily_forecast, params: { "city": 'some_city', "zipcode": zipcode }
      received_response = JSON.parse(response.body, symoblize_names: true)

      assert_response :not_found
      expect(received_response['error']).to eql("Weather forecast not found for #{zipcode} for today")
    end
  end
end
