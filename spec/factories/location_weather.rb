# frozen_string_literal: true

FactoryBot.define do
  factory(:location_weather) do
    zipcode { '13271' }
    current_temperature { 37.8 }
    city { 'some_city' }
    high_temperature { 43 }
    low_temperature { 21 }
    wind_speed { 12 }
    air_quality { 34 }
    air_pressure { 32 }
    humidity { 21 }
  end
end
