class LocationWeatherController < ApplicationController
  def index
    location_weather = LocationWeather.find_by(zipcode: params[:zipcode])
    render :json => {current_temperature: location_weather.current_temperature, cached: false}
  end
end
