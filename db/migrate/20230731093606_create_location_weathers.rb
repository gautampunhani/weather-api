# frozen_string_literal: true

class CreateLocationWeathers < ActiveRecord::Migration[7.0]
  def change
    create_table :location_weathers do |t|
      t.column :zipcode, :string
      t.column :city, :string
      t.column :current_temperature, :float
      t.column :high_temperature, :float
      t.column :low_temperature, :float
      t.column :wind_speed, :float
      t.column :air_quality, :int
      t.column :air_pressure, :float
      t.column :humidity, :int

      t.timestamps
    end
  end
end
