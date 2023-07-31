class LocationWeatherController < ApplicationController
  def index
    zipcode =  params[:zipcode]
    location_weather = LocationWeather.find_by(zipcode: zipcode)
    if location_weather.nil?
      render json: { error: "Zip code #{zipcode} not found" }, status: :not_found
    else
      render json: { current_temperature: location_weather.current_temperature, cached: false }
    end
  end
end

