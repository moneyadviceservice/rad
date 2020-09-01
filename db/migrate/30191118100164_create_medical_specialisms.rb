class CreateMedicalSpecialisms < ActiveRecord::Migration[5.2]
  def change
    create_table :medical_specialisms do |t|
      t.references :travel_insurance_firm, foreign_key: true
      t.string :specialised_medical_conditions_cover
      t.string :likely_not_cover_medical_condition
      t.boolean :cover_undergoing_treatment
      t.boolean :terminal_prognosis_cover

      t.timestamps
    end
  end
end
