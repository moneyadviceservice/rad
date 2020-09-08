class AddingMedicalCoronaRepatriationField < ActiveRecord::Migration[5.2]
  def change
    # rubocop:disable Rails/BulkChangeTable
    add_column :service_details, :covid19_medical_repatriation, :boolean
    add_column :service_details, :covid19_cancellation_cover, :boolean
    # rubocop:enable Rails/BulkChangeTable
  end
end
