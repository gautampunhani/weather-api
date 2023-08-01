FactoryBot.define do
  factory(:location_weather) do
    zipcode { '120129' }
    current_temperature { 37.8 }
  end
end