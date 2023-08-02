# frozen_string_literal: true

class WeatherReport
  attr_reader :high_temperature, :low_temperature, :humidity, :wind_speed, :date

  def initialize(weather_params)
    @high_temperature = weather_params[:high_temperature] || weather_params[:high_temperature.to_s]
    @low_temperature = weather_params[:low_temperature] || weather_params[:low_temperature.to_s]
    @humidity = weather_params[:humidity] || weather_params[:humidity.to_s]
    @wind_speed = weather_params[:wind_speed] || weather_params[:wind_speed.to_s]
    @date = weather_params[:date] || weather_params[:date.to_s]
    @zipcode = weather_params[:zipcode] || weather_params[:zipcode.to_s]
  end
end
