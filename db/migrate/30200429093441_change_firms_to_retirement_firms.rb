class ChangeFirmsToRetirementFirms < ActiveRecord::Migration[5.2]
  def change
    rename_table :firms, :retirement_firms
  end
  # TODO: remove the following fields and any associated indexed in a future refactor commit
  # - fca_number
  # - parent_id
end
