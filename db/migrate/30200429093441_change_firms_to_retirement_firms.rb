class ChangeFirmsToRetirementFirms < ActiveRecord::Migration[5.2]
  def change
    rename_table :firms, :retirement_firms
  end
  # TODO: Need a data migration to copy retirement firm details to the base firm before removing the fields
  # TODO: remove the following fields and any associated indexed in a future refactor commit
  # - fca_number
  # - parent_id
end
