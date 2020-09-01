class AddingMedicalCoronaRepatriationField < ActiveRecord::Migration[5.2]
  def change
    add_column :service_details, :covid19_medical_repatriation, :boolean
    add_column :service_details, :covid19_cancellation_cover, :boolean
  end
end
