class AddingMedicalCoronaRepatriationField < ActiveRecord::Migration[5.2]
  def change
    add_column :service_details, :covid19_medical_repatriation, :boolean # rubocop:disable Rails/BulkChangeTable
    add_column :service_details, :covid19_cancellation_cover, :boolean
  end
end
