class CreateSharedFirms < ActiveRecord::Migration[5.2]
  def change
    create_table :firms do |t|
      t.integer :fca_number, null: false
      t.integer 'parent_id'
      t.timestamps null: false
      t.string 'registered_name', null: false
      t.index :fca_number, unique: true
    end

    add_reference :firms, :retirement_firms, index: true
    add_reference :firms, :travel_insurance_firms, index: true
  end
end
