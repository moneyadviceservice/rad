class AddMediumPlusTripLength < ActiveRecord::Migration[5.2]
  def self.up
    add_column :trip_covers, :land_50_days_max_age, :integer, after: :land_45_days_max_age, before: :land_55_days_max_age
    add_column :trip_covers, :cruise_50_days_max_age, :integer, after: :cruise_45_days_max_age, before: :cruise_55_days_max_age

    TripCover.all.each do |tc|
      tc.land_50_days_max_age = tc.land_45_days_max_age
      tc.cruise_50_days_max_age = tc.cruise_45_days_max_age
      tc.save
    end
  end

  def self.down
    remove_column :trip_covers, :land_50_days_max_age
    remove_column :trip_covers, :cruise_50_days_max_age
  end
end
