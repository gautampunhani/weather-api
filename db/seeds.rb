# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

LocationWeather.destroy_all
LocationWeather.create([
  {zipcode: "13271",
   city: "some_city",
   current_temperature:37.8,
   high_temperature:43.0,
   low_temperature:21.0,
   wind_speed:12.0,
   air_quality:34,
   air_pressure:32.0,
   humidity:21},

  {zipcode: "15471",
   city: "some_city",
   current_temperature:37.8,
   high_temperature:43.0,
   low_temperature:21.0,
   wind_speed:12.0,
   air_quality:34,
   air_pressure:32.0,
   humidity:21}
])

p "Created #{LocationWeather.count} weather reports"
