require 'rails_helper'

describe LocationWeatherController do
  before(:each) do
    @location_weather = create(:location_weather)
  end

  describe 'without cache' do

    it "should return weather of the given city" do
      location_weather_second = create(:location_weather, zipcode: '132810', current_temperature: 53)

      get :index, params: {"city": 'some_city', "zipcode": '132710'}

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      assert_equal @location_weather.current_temperature, received_response["current_temperature"]
      assert_equal @location_weather.current_temperature, received_response["current_temperature"]
    end

    it "should return error if zipcode doesn't exist" do

      get :index, params: {"city": 'some_city', "zipcode": '142710'}
      received_response = JSON.parse(response.body, symoblize_names: true)
      assert_response :not_found
    end
  end

  describe 'with cache' do

    let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
    let(:cache) { Rails.cache }

    before do
      allow(Rails).to receive(:cache).and_return(memory_store)
      Rails.cache.clear
    end

    it "should return cache flag as false if location weather not found in cache" do

      get :index, params: {"city": 'some_city', "zipcode": '132710'}

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      assert_equal false, received_response["cached"]
    end

    it "should fetch the object from cache on subsequent requests" do

      get :index, params: {"city": 'some_city', "zipcode": '132710'}

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      assert_equal false, received_response["cached"]

      get :index, params: {"city": 'some_city', "zipcode": '132710'}

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      assert_equal true, received_response["cached"]
    end

    it "should fetch object from database if record is invalidated" do

      get :index, params: {"city": 'some_city', "zipcode": '132710'}

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      assert_equal false, received_response["cached"]

      get :index, params: {"city": 'some_city', "zipcode": '132710'}

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      assert_equal true, received_response["cached"]


      @location_weather.current_temperature=47.0
      @location_weather.save!
      get :index, params: {"city": 'some_city', "zipcode": '132710'}

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      assert_equal false, received_response["cached"]
    end

    xit "should fetch from database after 30 minutes instead of cache" do

    end
  end
end
