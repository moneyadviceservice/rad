class AddHiddenAtToFirms < ActiveRecord::Migration[5.2]
  def up
    add_column :travel_insurance_firms, :hidden_at, :datetime
    add_index :travel_insurance_firms, :hidden_at
    add_column :firms, :hidden_at, :datetime
    add_index :firms, :hidden_at
  end

  def down
    remove_column :travel_insurance_firms, :hidden_at
    remove_column :firms, :hidden_at
  end

end