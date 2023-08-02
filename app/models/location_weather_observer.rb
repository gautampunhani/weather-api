# frozen_string_literal: true

require_relative '../common/constants'

class LocationWeatherObserver < ActiveRecord::Observer
  observe :LocationWeather

  def after_save(location_weather)
    if (location_weather.forecast_for < Date.today.end_of_day) && (location_weather.forecast_for > Date.today.beginning_of_day)
      Rails.cache.delete(LocationWeatherObserver.caching_key(location_weather.zipcode, Date.today))
    end

    if (location_weather.forecast_for < WeatherAPIConstants::EXTENDED_FORECAST_TILL_DAYS.from_now) &&
       (location_weather.forecast_for > Date.today.beginning_of_day)
      Rails.cache.delete(LocationWeatherObserver.caching_key_extended(location_weather.zipcode, Date.today))
    end
  end

  class << self
    def caching_key(zipcode, date)
      "weather_data_#{zipcode}_#{date.strftime('%d_%m_%Y')}"
    end

    def caching_key_extended(zipcode, date)
      "weather_data_#{zipcode}_#{date.strftime('%d_%m_%Y')}_extended"
    end
  end
end
