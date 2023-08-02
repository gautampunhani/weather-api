# frozen_string_literal: true

class LocationWeather < ApplicationRecord
  CURRENT_WEATHER_RANGE_IN_HOURS = 4.hours

  def self.current_weather(zipcode)
    by_zipcode(zipcode)
      .order_latest
      .weather_in_date_range({ start_date: Time.now - CURRENT_WEATHER_RANGE_IN_HOURS, end_date: Time.now })
      .first
  end

  def self.aggregate_weather_by_date(zipcode, start_date, end_date)
    ActiveRecord::Base.connection.execute(by_zipcode(zipcode)
      .aggregate_weather_stats
      .weather_in_date_range({ start_date: start_date, end_date: end_date })
      .to_sql)
  end

  def as_json
    super except: %i[id created_at updated_at]
  end

  scope :weather_in_date_range, lambda { |params|
    where('forecast_for >= ?', params[:start_date])
      .where('forecast_for <= ?', params[:end_date])
  }

  scope :aggregate_weather_stats, lambda {
    group('DATE(forecast_for), zipcode')
      .order('date asc')
      .select('zipcode',
              'max(temperature) as high_temperature',
              'min(temperature) as low_temperature',
              'avg(humidity) as humidity',
              'avg(wind_speed) as wind_speed',
              'DATE(forecast_for) as date')
  }
  scope :by_zipcode, ->(zipcode) { where(zipcode: zipcode) }
  scope :order_latest, -> { order(forecast_for: :desc) }
end
