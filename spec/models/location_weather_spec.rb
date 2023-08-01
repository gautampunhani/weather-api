require 'rails_helper'

describe LocationWeather do
  describe "caching_key" do
    it "should set caching key for zipcode" do
      zipcode = '12345'
      expected_key = "weather_data_#{zipcode}"

      result = LocationWeather.caching_key(zipcode)
      assert_equal expected_key, result

    end
  end
end