class CreateServiceDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :service_details do |t|
      t.references :travel_insurance_firm, foreign_key: true
      t.boolean :offers_telephone_quote
      t.integer :cover_for_specialist_equipment
      t.string :medical_screening_company
      t.string :how_far_in_advance_trip_cover

      t.timestamps
    end
  end
end
