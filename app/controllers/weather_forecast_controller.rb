# frozen_string_literal: true

class WeatherForecastController < ApplicationController
  ZIPCODE_VALIDATION_PATTERN = /^\d{5}$/

  before_action :validate_params, only: %i[daily_forecast extended_forecast]

  def daily_forecast
    zipcode = params[:zipcode]

    current_forecast = WeatherForecastService.current_forecast(zipcode)

    if current_forecast[:current].nil?
      render json: { error: "Weather forecast not found for #{zipcode} for today" }, status: :not_found
    else
      render json: current_forecast
    end
  end

  def extended_forecast
    zipcode = params[:zipcode]

    extended_forecast = WeatherForecastService.extended_forecast(zipcode)

    if extended_forecast[:daily_extended_forecast].empty?
      render json: { error: "Extended weather forecast not found for #{zipcode}" }, status: :not_found
    else
      render json: extended_forecast
    end
  end

  private

  def valid_zipcode?(zipcode)
    ZIPCODE_VALIDATION_PATTERN.match?(zipcode)
  end

  def validate_params
    zipcode = params['zipcode']
    if zipcode.blank?
      render json: { error: 'Zipcode cannot be blank' }, status: 400
    elsif !valid_zipcode?(zipcode)
      render json: { error: 'Invalid zipcode format' }, status: 400
    end
    params.permit(:zipcode, :country, :city)

  end
end
