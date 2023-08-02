# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'WeatherForecast', type: :request do
  path '/forecast/daily' do
    get 'fetch latest weather report for a zipcode' do
      tags 'WeatherReport'
      produces 'application/json'
      parameter name: :zipcode, in: :query, type: :string, required: true
      parameter name: :city, in: :query, type: :string, required: false
      parameter name: :country, in: :query, type: :string, required: false

      response '200', 'Weather report found' do
        schema type: :object,
               properties: {
                 current: {
                   type: :object,
                   properties: {
                     zipcode: { type: :string },
                     city: { type: :string },
                     temperature: { type: :decimal },
                     forecast_for: { type: :string },
                     humidity: { type: :integer },
                     wind_speed: { type: :integer }
                   }
                 },
                 day_summary: {
                   type: :object,
                   properties: {
                     zipcode: { type: :string },
                     humidity: { type: :decimal },
                     wind_speed: { type: :decimal },
                     date: { type: :string },
                     high_temperature: { type: :decimal },
                     low_temperature: { type: :decimal }
                   }
                 },
                 cached: { type: :boolean }
               }

        let(:zipcode) { FactoryBot.create(:location_weather).zipcode }
        run_test!
      end

      response '400', 'Zip code is not valid' do
        let(:zipcode) { 'AZYS2' }
        run_test!
      end

      response '400', 'Zip code should not be blank' do
        let(:zipcode) { '' }
        run_test!
      end

      response '404', 'Weather not found for today for the zipcode' do
        let(:zipcode) { FactoryBot.create(:location_weather_tomorrow).zipcode }
        run_test!
      end
    end
  end

  path '/forecast/extended' do
    get 'fetch latest weather report for a zipcode' do
      tags 'WeatherReport'
      produces 'application/json'
      parameter name: :zipcode, in: :query, type: :string, required: true
      parameter name: :city, in: :query, type: :string, required: false
      parameter name: :country, in: :query, type: :string, required: false

      response '200', 'Weather report found' do
        schema type: :object,
               properties: {
                 daily_extended_forecast: {
                   type: :array,
                   properties: {
                     zipcode: { type: :string },
                     humidity: { type: :decimal },
                     wind_speed: { type: :decimal },
                     date: { type: :string },
                     high_temperature: { type: :decimal },
                     low_temperature: { type: :decimal }
                   }
                 },
                 cached: { type: :boolean }
               }

        let(:zipcode) { FactoryBot.create(:location_weather).zipcode }
        run_test!
      end

      response '400', 'Zip code is not valid' do
        let(:zipcode) { 'AZYS2' }
        run_test!
      end

      response '400', 'Zip code should not be blank' do
        let(:zipcode) { '' }
        run_test!
      end

      response '404', 'Weather not found for today for the zipcode' do
        let(:zipcode) { FactoryBot.create(:location_weather, forecast_for: 20.days.from_now).zipcode }
        run_test!
      end
    end
  end
end
