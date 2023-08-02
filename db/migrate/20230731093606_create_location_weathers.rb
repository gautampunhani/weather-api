# frozen_string_literal: true

class CreateLocationWeathers < ActiveRecord::Migration[7.0]
  def change
    create_table :location_weathers do |t|
      t.column :zipcode, :string
      t.column :city, :string
      t.column :temperature, :float
      t.column :forecast_for, :Timestamp
      t.column :humidity, :int
      t.column :wind_speed, :int

      t.timestamps
    end
  end
end
