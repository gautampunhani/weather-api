# frozen_string_literal: true

require 'rails_helper'

describe 'LocationWeatherObserver' do
  describe 'cache invalidation' do
    let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
    let(:cache) { Rails.cache }

    before do
      allow(Rails).to receive(:cache).and_return(memory_store)
      Rails.cache.clear
    end

    it 'should invalidate cache of current forecast if location_weather is updated and is in range' do
      location_weather = create(:location_weather)
      observer = LocationWeatherObserver.instance
      Rails.cache.write(LocationWeatherObserver.caching_key(location_weather.zipcode, Date.today), location_weather)
      expect(Rails.cache.read(LocationWeatherObserver.caching_key(location_weather.zipcode, Date.today))).to_not be_nil

      observer.after_save(location_weather)

      expect(Rails.cache.read(LocationWeatherObserver.caching_key(location_weather.zipcode, Date.today))).to be_nil
    end

    it 'should not remove cache of current forecast if location_weather is not for today' do
      location_weather = create(:location_weather)
      observer = LocationWeatherObserver.instance
      Rails.cache.write(LocationWeatherObserver.caching_key(location_weather.zipcode, Date.today), location_weather)
      expect(Rails.cache.read(LocationWeatherObserver.caching_key(location_weather.zipcode, Date.today))).to_not be_nil

      location_weather.forecast_for = 2.days.from_now

      observer.after_save(location_weather)

      expect(Rails.cache.read(LocationWeatherObserver.caching_key(location_weather.zipcode, Date.today))).to_not be_nil
    end

    it 'should not remove cache of extended forecast if location_weather is not for next 14 days' do
      location_weather = create(:location_weather)
      observer = LocationWeatherObserver.instance
      Rails.cache.write(LocationWeatherObserver.caching_key_extended(location_weather.zipcode, Date.today),
                        location_weather)
      expect(Rails.cache.read(LocationWeatherObserver.caching_key_extended(location_weather.zipcode,
                                                                           Date.today))).to_not be_nil

      location_weather.forecast_for = 16.days.from_now

      observer.after_save(location_weather)

      expect(Rails.cache.read(LocationWeatherObserver.caching_key_extended(location_weather.zipcode,
                                                                           Date.today))).to_not be_nil
    end

    it 'should invalidate cache of extended forecast if location_weather is updated and is in range' do
      location_weather = create(:location_weather)
      observer = LocationWeatherObserver.instance
      Rails.cache.write(LocationWeatherObserver.caching_key_extended(location_weather.zipcode, Date.today),
                        location_weather)
      expect(Rails.cache.read(LocationWeatherObserver.caching_key_extended(location_weather.zipcode,
                                                                           Date.today))).to_not be_nil

      observer.after_save(location_weather)

      expect(Rails.cache.read(LocationWeatherObserver.caching_key_extended(location_weather.zipcode,
                                                                           Date.today))).to be_nil
    end
  end
end
