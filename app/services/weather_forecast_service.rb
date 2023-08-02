# frozen_string_literal: true

class WeatherForecastService
  class << self
    def current_forecast(zipcode)
      found_from_cache = true
      current_weather_forecast = Rails.cache.fetch(LocationWeatherObserver.caching_key(zipcode, Date.today),
                                                   expires_in: WeatherAPIConstants::CACHE_EXPIRY_MINUTES) do
        current_weather = LocationWeather.current_weather(zipcode)
        report_for_today = LocationWeather
                           .aggregate_weather_by_date(zipcode, Date.today.beginning_of_day, Date.today.end_of_day)
                           .map { |weather_aggregate| WeatherReport.new(weather_aggregate) }.first

        found_from_cache = false
        { current: current_weather.as_json, day_summary: report_for_today }
      end

      current_weather_forecast[:cached] = found_from_cache
      current_weather_forecast
    end

    def extended_forecast(zipcode)
      found_from_cache = true
      extended_forecast = Rails.cache.fetch(LocationWeatherObserver.caching_key_extended(zipcode, Date.today),
                                            expires_in: WeatherAPIConstants::CACHE_EXPIRY_MINUTES) do
        found_from_cache = false

        weather_reports = LocationWeather
                          .aggregate_weather_by_date(zipcode, Date.today.beginning_of_day, WeatherAPIConstants::EXTENDED_FORECAST_TILL_DAYS.from_now)
                          .map { |weather_aggregate| WeatherReport.new(weather_aggregate) }
        { daily_extended_forecast: weather_reports }
      end

      extended_forecast[:cached] = found_from_cache
      extended_forecast
    end
  end
end
