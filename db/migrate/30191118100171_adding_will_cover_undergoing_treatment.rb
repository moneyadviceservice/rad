class AddingWillCoverUndergoingTreatment < ActiveRecord::Migration[5.2]
  def change
    add_column :medical_specialisms, :will_cover_undergoing_treatment, :boolean # rubocop:disable Rails/BulkChangeTable
    change_column :medical_specialisms, :cover_undergoing_treatment, :string
  end
end
