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
                         { zipcode: "13271",
                           city: "some_city",
                           temperature: 37.8,
                           humidity: 23,
                           wind_speed: 45,
                           forecast_for: Time.now
                         },
                         {
                           zipcode: "13271",
                           city: "some_city",
                           temperature: 38.8,
                           humidity: 23,
                           wind_speed: 45,
                           forecast_for: Time.now+2.hours
                         },
                         {
                           zipcode: "13271",
                           city: "some_city",
                           temperature: 39.8,
                           humidity: 23,
                           wind_speed: 45,
                           forecast_for: Time.now+4.hours
                         },
                         { zipcode: "15471",
                           city: "some_city",
                           temperature: 37.8,
                           humidity: 23,
                           wind_speed: 45,
                           forecast_for: Time.now+2.days
                         }
                       ])

#Create extended forecast for more no of days for 1 zipcode
LocationWeather.create([
                         { zipcode: "14141",
                           city: "some_city",
                           temperature: 37.8,
                           humidity: 23,
                           wind_speed: 45,
                           forecast_for: Time.now
                         },
                         {
                           zipcode: "14141",
                           city: "some_city",
                           temperature: 35.8,
                           humidity: 23,
                           wind_speed: 45,
                           forecast_for: Time.now+2.hours
                         },
                         {
                           zipcode: "14141",
                           city: "some_city",
                           temperature: 39.8,
                           humidity: 23,
                           wind_speed: 45,
                           forecast_for: Time.now+1.day
                         },
                         { zipcode: "14141",
                           city: "some_city",
                           temperature: 37.8,
                           humidity: 23,
                           wind_speed: 45,
                           forecast_for: Time.now+2.days
                         },
                         { zipcode: "14141",
                           city: "some_city",
                           temperature: 37.8,
                           humidity: 23,
                           wind_speed: 45,
                           forecast_for: Time.now+2.days+4.hours
                         },
                         { zipcode: "14141",
                           city: "some_city",
                           temperature: 25.0,
                           humidity: 23,
                           wind_speed: 45,
                           forecast_for: Time.now+3.days
                         },
                         { zipcode: "14141",
                           city: "some_city",
                           temperature: 53.0,
                           humidity: 23,
                           wind_speed: 45,
                           forecast_for: Time.now+23.days
                         }
                       ])

p "Created #{LocationWeather.count} weather captured events"
