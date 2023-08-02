# frozen_string_literal: true

FactoryBot.define do
  factory(:location_weather) do
    zipcode { '13271' }
    temperature { 37.8 }
    city { 'some_city' }
    forecast_for { Time.now }
    humidity { 21 }
    wind_speed { 12 }
  end

  factory(:location_weather_tomorrow, class: LocationWeather) do
    zipcode { '17281' }
    temperature { 37.8 }
    city { 'some_city' }
    forecast_for { Time.now + 1.day }
    humidity { 21 }
    wind_speed { 12 }
  end

  factory(:weather_report, class: WeatherReport) do
    zipcode { '13271' }
    high_temperature { 37.8 }
    low_temperature { 37.8 }
    date { Date.today.to_s }
    humidity { 21.0 }
    wind_speed { 12.0 }

    skip_create
    initialize_with do
      new({ "high_temperature": high_temperature,
            "low_temperature": low_temperature,
            "date": date,
            "zipcode": zipcode,
            "humidity": humidity,
            "wind_speed": wind_speed })
    end
  end

  factory :current_forecast, class: Hash do
    cached { false }
    current { create(:location_weather) }
    day_summary { create(:weather_report) }

    skip_create

    # Tell the factory how to initialize this non-standard set of data
    initialize_with { attributes }
  end

  factory :extended_forecast, class: Hash do
    daily_extended_forecast { 15.times.collect { |i| create(:weather_report, date: (Date.today + i.days).to_s) } }
    cached { false }

    skip_create

    # Tell the factory how to initialize this non-standard set of data
    initialize_with { attributes }
  end
end
