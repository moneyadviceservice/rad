class CreateTravelInsuranceFirms < ActiveRecord::Migration[5.2]
  def change
    create_table :travel_insurance_firms do |t|
      t.integer :fca_number, null: false
      t.string :registered_name, null: false
      t.datetime :approved_at

      t.index :fca_number, unique: true
      t.index :approved_at

      t.timestamps
    end
  end
end
