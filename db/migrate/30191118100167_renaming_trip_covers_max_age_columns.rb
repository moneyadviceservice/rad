class RenamingTripCoversMaxAgeColumns < ActiveRecord::Migration[5.2]
  def change
    rename_column :trip_covers, :one_month_land_max_age, :land_30_days_max_age
    rename_column :trip_covers, :one_month_cruise_max_age, :cruise_30_days_max_age

    rename_column :trip_covers, :six_month_land_max_age, :land_45_days_max_age
    rename_column :trip_covers, :six_month_cruise_max_age, :cruise_45_days_max_age

    rename_column :trip_covers, :six_month_plus_land_max_age, :land_55_days_max_age
    rename_column :trip_covers, :six_month_plus_cruise_max_age, :cruise_55_days_max_age
  end
end
