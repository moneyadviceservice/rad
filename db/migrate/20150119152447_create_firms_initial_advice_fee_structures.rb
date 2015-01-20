class CreateFirmsInitialAdviceFeeStructures < ActiveRecord::Migration
  def change
    create_table :firms_initial_advice_fee_structures, id: false do |t|
      t.belongs_to :firm, index: true
      t.belongs_to :initial_advice_fee_structure
    end

    add_index :firms_initial_advice_fee_structures, :initial_advice_fee_structure_id,
              name: 'firms_initial_advice_fee_structs_initial_advice_fee_struct_id'
  end
end
