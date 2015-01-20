class CreateFirmsOngoingAdviceFeeStructures < ActiveRecord::Migration
  def change
    create_table :firms_ongoing_advice_fee_structures, id: false do |t|
      t.belongs_to :firm, index: true
      t.belongs_to :ongoing_advice_fee_structure
    end

    add_index :firms_ongoing_advice_fee_structures, :ongoing_advice_fee_structure_id,
              name: 'firms_ongoing_advice_fee_structs_ongoing_advice_fee_struct_id'
  end
end
