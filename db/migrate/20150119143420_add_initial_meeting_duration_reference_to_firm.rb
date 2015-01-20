class AddInitialMeetingDurationReferenceToFirm < ActiveRecord::Migration
  def change
    add_reference :firms, :initial_meeting_duration, index: true
  end
end
