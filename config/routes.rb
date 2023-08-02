# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  root to: redirect('/api-docs')
  get 'forecast/daily' => 'weather_forecast#daily_forecast'
  get 'forecast/extended' => 'weather_forecast#extended_forecast'
end
