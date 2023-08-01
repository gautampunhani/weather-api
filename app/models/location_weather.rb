class LocationWeather < ApplicationRecord
  def self.caching_key(zipcode)
    "weather_data_#{zipcode}"
  end

  after_save do |location_weather|
    Rails.cache.delete(LocationWeather.caching_key(location_weather.zipcode))
  end
end
