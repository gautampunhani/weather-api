class LocationWeatherController < ApplicationController
  def index
    zipcode = params[:zipcode]
    found_from_cache = true

    location_weather = Rails.cache.fetch(LocationWeather.caching_key(zipcode)) do
      found_from_cache = false
      LocationWeather.find_by(zipcode: zipcode)
    end

    if location_weather.nil?
      render json: { error: "Zip code #{zipcode} not found" }, status: :not_found
    else
      render json: { current_temperature: location_weather.current_temperature, cached: found_from_cache }
    end
  end
end

