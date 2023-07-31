require 'rails_helper'

describe LocationWeatherController do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  describe 'without cache' do
    it "should return weather of the given city" do
      location_weather = LocationWeather.new({zipcode: '132710', city: 'some_city', 'current_temperature': 45})
      location_weather.save!
      location_weather_second = LocationWeather.new({zipcode: '132810', city: 'some_city', 'current_temperature': 53})
      location_weather_second.save!
      get :index, params: {"city": 'some_city', "zipcode": '132710'}

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      assert_equal location_weather.current_temperature, received_response["current_temperature"]
    end

    xit "should return error if zipcode doesn't exist" do
      location_weather = LocationWeather.new({zipcode: '132710', city: 'some_city', 'current_temperature': 45})
      location_weather.save!
      location_weather_second = LocationWeather.new({zipcode: '132810', city: 'some_city', 'current_temperature': 53})
      location_weather_second.save!
      get :index, params: {"city": 'some_city', "zipcode": '142710'}

      assert_response :fail
    end


  end

  describe 'with cache' do
    it "should return cache flag as false if location weather not found in cache" do
      location_weather = LocationWeather.new({zipcode: '132710', city: 'some_city', 'current_temperature': 45})
      location_weather.save!
      get :index, params: {"city": 'some_city', "zipcode": '132710'}

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      assert_equal false, received_response["cached"]
    end

    xit "should fetch the object from cache on subsequent requests" do
      location_weather = LocationWeather.new({zipcode: '132710', city: 'some_city', 'current_temperature': 45})
      location_weather.save!

      get :index, params: {"city": 'some_city', "zipcode": '132710'}

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      assert_equal false, received_response["cached"]

      get :index, params: {"city": 'some_city', "zipcode": '132710'}

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      assert_equal true, received_response["cached"]
    end

    xit "should fetch object from database if record is invalidated" do
      location_weather = LocationWeather.new({zipcode: '132710', city: 'some_city', 'current_temperature': 45})
      location_weather.save!

      get :index, params: {"city": 'some_city', "zipcode": '132710'}

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      assert_equal false, received_response["cached"]

      get :index, params: {"city": 'some_city', "zipcode": '132710'}

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      assert_equal true, received_response["cached"]


      location_weather.current_temperature=47.0
      location_weather.save!
      get :index, params: {"city": 'some_city', "zipcode": '132710'}

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      assert_equal false, received_response["cached"]
    end
  end
end
