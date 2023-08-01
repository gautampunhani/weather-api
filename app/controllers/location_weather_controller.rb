# frozen_string_literal: true

class LocationWeatherController < ApplicationController
  ZIPCODE_VALIDATION_PATTERN = /^\d{5}$/
  CACHE_EXPIRY = 30

  before_action :validate_params

  def index
    zipcode = params[:zipcode]
    found_from_cache = true

    location_weather = Rails.cache.fetch(LocationWeather.caching_key(zipcode), expires_in: CACHE_EXPIRY.minutes) do
      found_from_cache = false
      LocationWeather.find_by(zipcode: zipcode)
    end

    if location_weather.nil?
      render json: { error: "Zip code #{zipcode} not found" }, status: :not_found
    else
      location_weather_json = location_weather.as_json.merge(cached: found_from_cache).to_json
      render json: location_weather_json
    end
  end

  def valid_zipcode?(zipcode)
    ZIPCODE_VALIDATION_PATTERN.match?(zipcode)
  end

  def validate_params
    zipcode = params['zipcode']
    if zipcode.blank?
      render json: { error: 'Zipcode cannot be blank' }, status: 400
    elsif !valid_zipcode?(zipcode)
      render json: { error: 'Invalid zipcode format' }, status: 400
    end
  end
end
