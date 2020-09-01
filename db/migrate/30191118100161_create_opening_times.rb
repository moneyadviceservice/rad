class CreateOpeningTimes < ActiveRecord::Migration[5.2]
  def change
    create_table :opening_times do |t|
      t.references :office, foreign_key: true
      t.time :weekday_opening_time
      t.time :weekday_closing_time
      t.time :saturday_opening_time
      t.time :saturday_closing_time
      t.time :sunday_opening_time
      t.time :sunday_closing_time

      t.timestamps
    end
  end
end
