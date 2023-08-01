# frozen_string_literal: true

require 'rails_helper'

describe LocationWeather do
  describe 'caching_key' do
    it 'should set caching key for zipcode' do
      zipcode = '12345'
      expected_key = "weather_data_#{zipcode}"

      result = LocationWeather.caching_key(zipcode)
      assert_equal expected_key, result
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
