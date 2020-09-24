class RemovingFirmIdFromInactiveFirms < ActiveRecord::Migration[5.2]
  def change
    remove_column :inactive_firms, :firm_id, :integer
  end
end
