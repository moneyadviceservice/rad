class CreateFirmsInPersonAdviceMethods < ActiveRecord::Migration
  def change
    create_table :firms_in_person_advice_methods, id: false do |t|
      t.belongs_to :firm
      t.belongs_to :in_person_advice_method
    end

    add_index :firms_in_person_advice_methods, :firm_id,
              name: 'in_person_advice_methods_firm_id'

    add_index :firms_in_person_advice_methods, :in_person_advice_method_id,
              name: 'in_person_advice_methods_in_person_advice_method_id'
  end
end
