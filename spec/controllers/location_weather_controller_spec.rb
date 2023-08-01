# frozen_string_literal: true

require 'rails_helper'
describe LocationWeatherController do
  before(:each) do
    @location_weather = create(:location_weather)
  end

  describe 'validate params' do
    it 'should return error json with bad request if zipcode is not passed' do
      message = 'Zipcode cannot be blank'
      get :index, params: { "city": 'some_city', "zipcode": '' }
      received_response = JSON.parse(response.body, symoblize_names: true)
      # require 'pry'; binding.pry

      assert_response :bad_request
      expect(message).to eql(received_response['error'])
    end

    it 'should return error json with bad request if zipcode is not not valid' do
      message = 'Invalid zipcode format'
      get :index, params: { "city": 'some_city', "zipcode": '565656' }
      received_response = JSON.parse(response.body, symoblize_names: true)

      assert_response :bad_request
      expect(message).to eql(received_response['error'])
    end
  end

  describe 'without cache' do
    it 'should return weather of the given city' do
      create(:location_weather, zipcode: '13281', current_temperature: 53)

      get :index, params: { "city": 'some_city', "zipcode": '13271' }

      assert_response :success

      received_response =  JSON.parse(response.body, symoblize_names: true)
      columns = %i[zipcode current_temperature city high_temperature low_temperature wind_speed air_quality
                   air_pressure humidity]
      columns.each do |field|
        assert_equal @location_weather[field], received_response[field.to_s]
      end

      res = received_response.keys.filter { |key| !(columns.include?(key.to_sym) || key.to_sym === :cached) }
      expect(res).to be_empty
    end

    it "should return error if zipcode doesn't exist" do
      message = 'Zip code 14271 not found'
      get :index, params: { "city": 'some_city', "zipcode": '14271' }
      received_response = JSON.parse(response.body, symoblize_names: true)

      assert_response :not_found
      expect(message).to eql(received_response['error'])
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
      get :index, params: { "city": 'some_city', "zipcode": '13271' }

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      assert_equal false, received_response['cached']
    end

    it 'should fetch the object from cache on subsequent requests' do
      get :index, params: { "city": 'some_city', "zipcode": '13271' }

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      assert_equal false, received_response['cached']

      get :index, params: { "city": 'some_city', "zipcode": '13271' }

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      assert_equal true, received_response['cached']
    end

    it 'should fetch object from database if record is invalidated' do
      get :index, params: { "city": 'some_city', "zipcode": '13271' }

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      assert_equal false, received_response['cached']

      get :index, params: { "city": 'some_city', "zipcode": '13271' }

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      assert_equal true, received_response['cached']

      @location_weather.current_temperature = 47.0
      @location_weather.save!
      get :index, params: { "city": 'some_city', "zipcode": '13271' }

      assert_response :success

      received_response = JSON.parse(response.body, symoblize_names: true)
      assert_equal false, received_response['cached']
    end

    xit 'should fetch from database after 30 minutes instead of cache' do
    end
  end
end
