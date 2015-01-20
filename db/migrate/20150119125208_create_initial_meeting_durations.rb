class CreateInitialMeetingDurations < ActiveRecord::Migration
  def change
    create_table :initial_meeting_durations do |t|
      t.integer :duration, unique: true

      t.timestamps null: false
    end
  end
end
