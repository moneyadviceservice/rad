class CreateTripCovers < ActiveRecord::Migration[5.2]
  def change
    create_table :trip_covers do |t|
      t.references :travel_insurance_firm, foreign_key: true
      t.string :trip_type
      t.string :cover_area
      t.string :one_month_land_max_age
      t.string :one_month_cruise_max_age
      t.string :six_month_land_max_age
      t.string :six_month_cruise_max_age
      t.string :six_month_plus_land_max_age
      t.string :six_month_plus_cruise_max_age

      t.timestamps
    end
  end
end
