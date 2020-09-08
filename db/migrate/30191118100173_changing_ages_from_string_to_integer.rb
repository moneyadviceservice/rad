class ChangingAgesFromStringToInteger < ActiveRecord::Migration[5.2]
  def change
    # rubocop:disable Rails/BulkChangeTable
    remove_column :trip_covers, :land_30_days_max_age, :string
    add_column :trip_covers, :land_30_days_max_age, :integer
    remove_column :trip_covers, :cruise_30_days_max_age, :string
    add_column :trip_covers, :cruise_30_days_max_age, :integer
    remove_column :trip_covers, :land_45_days_max_age, :string
    add_column :trip_covers, :land_45_days_max_age, :integer
    remove_column :trip_covers, :cruise_45_days_max_age, :string
    add_column :trip_covers, :cruise_45_days_max_age, :integer
    remove_column :trip_covers, :land_55_days_max_age, :string
    add_column :trip_covers, :land_55_days_max_age, :integer
    remove_column :trip_covers, :cruise_55_days_max_age, :string
    add_column :trip_covers, :cruise_55_days_max_age, :integer
    # rubocop:enable Rails/BulkChangeTable
  end
end
