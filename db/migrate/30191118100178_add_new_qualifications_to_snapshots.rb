class AddNewQualificationsToSnapshots < ActiveRecord::Migration[5.2]
  def change
  	add_column :snapshots, :advisers_with_qualification_in_chartered_associate, :integer, default: 0
  	add_column :snapshots, :advisers_with_qualification_in_chartered_fellow, :integer, default: 0
  end
end
