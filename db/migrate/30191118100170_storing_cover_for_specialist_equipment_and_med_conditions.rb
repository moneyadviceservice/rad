class StoringCoverForSpecialistEquipmentAndMedConditions < ActiveRecord::Migration[5.2]
  def change
    add_column :medical_specialisms, :will_not_cover_some_medical_conditions, :boolean
    add_column :service_details, :will_cover_specialist_equipment, :boolean
  end
end
