# frozen_string_literal: true

Rails.application.routes.draw do
  get 'location_weather' => 'location_weather#find_by_zipcode'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
