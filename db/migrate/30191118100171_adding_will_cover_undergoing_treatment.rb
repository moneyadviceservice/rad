class AddingWillCoverUndergoingTreatment < ActiveRecord::Migration[5.2]
  def change
    # rubocop:disable Rails/BulkChangeTable
    add_column :medical_specialisms, :will_cover_undergoing_treatment, :boolean
    change_column :medical_specialisms, :cover_undergoing_treatment, :string
    # rubocop:enable Rails/BulkChangeTable
  end
end
