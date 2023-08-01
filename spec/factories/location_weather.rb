FactoryBot.define do
  factory(:location_weather) do
    zipcode { '132710' }
    current_temperature { 37.8 }
    city {'some_city'}
  end
end