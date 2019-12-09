class AddUniqueConstraintToInactiveFirmsFirmId < ActiveRecord::Migration[5.2]
  def change
    InactiveFirm.delete_all
    remove_index :inactive_firms, :firm_id
    add_index :inactive_firms, :firm_id, unique: true
  end
end
