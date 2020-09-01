class AddingMedicalSpecialismCoverField < ActiveRecord::Migration[5.2]
  def change
    add_column :medical_specialisms, :specialised_medical_conditions_covers_all, :boolean, default: true
  end
end
