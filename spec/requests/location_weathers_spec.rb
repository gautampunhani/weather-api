require 'rails_helper'

RSpec.describe "LocationWeathers", type: :request do
  describe "GET /location_weathers" do
    it "should fetch the weather report" do
      create(:location_weather)

      get "/location_weather/index", params: { "city": 'some_city', "zipcode": '13271' }

      expect(response).to have_http_status(200)
      expected_response = JSON.parse("{\"zipcode\":\"13271\",\"city\":\"some_city\",\"current_temperature\":37.8,\"high_temperature\":43.0,\"low_temperature\":21.0,\"wind_speed\":12.0,\"air_quality\":34,\"air_pressure\":32.0,\"humidity\":21,\"cached\":false}")
      expect(JSON.parse(response.body)).to eql(expected_response)
    end

    it "should give 404 for zipcode not existing" do
      create(:location_weather)

      get "/location_weather/index", params: { "city": 'some_city', "zipcode": '12121' }

      expect(response).to have_http_status(404)
    end
  end
end
