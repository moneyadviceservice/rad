class CreateInitialAdviceFeeStructures < ActiveRecord::Migration
  def change
    create_table :initial_advice_fee_structures do |t|
      t.string :name, unique: true

      t.timestamps null: false
    end
  end
end
