class ChangeFirmsToRetirementFirms < ActiveRecord::Migration[5.2]
  def change
    rename_table :firms, :retirement_firms
    # TODO: Need a data migration to copy retirement firm details to the base firm before removing the fields
    # TODO: remove the following fields and any associated indexed in a future refactor commit
    # - fca_number
    # - parent_id

    rename_table :firms_in_person_advice_methods, :in_person_advice_methods_retirement_firms
    rename_column :in_person_advice_methods_retirement_firms, :firm_id, :retirement_firm_id
    rename_table :firms_initial_advice_fee_structures, :initial_advice_fee_structures_retirement_firms
    rename_column :initial_advice_fee_structures_retirement_firms, :firm_id, :retirement_firm_id
    rename_table :firms_investment_sizes, :investment_sizes_retirement_firms
    rename_column :investment_sizes_retirement_firms, :firm_id, :retirement_firm_id
    rename_table :firms_ongoing_advice_fee_structures, :ongoing_advice_fee_structures_retirement_firms
    rename_column :ongoing_advice_fee_structures_retirement_firms, :firm_id, :retirement_firm_id
    rename_table :firms_other_advice_methods, :other_advice_methods_retirement_firms
    rename_column :other_advice_methods_retirement_firms, :firm_id, :retirement_firm_id
    rename_table :inactive_firms, :retirement_firms_inactive
    rename_column :retirement_firms_inactive, :firm_id, :retirement_firm_id
    rename_table :offices, :office_retirement_firms
    rename_column :office_retirement_firms, :firm_id, :retirement_firm_id
    rename_table :advisers, :advisers_retirement_firms
    rename_column :advisers_retirement_firms, :firm_id, :retirement_firm_id
    rename_table :allowed_payment_methods_firms, :allowed_payment_methods_retirement_firms
    rename_column :allowed_payment_methods_retirement_firms, :firm_id, :retirement_firm_id

    remove_column :retirement_firms, :fca_number, :integer
    remove_column :retirement_firms, :parent_id, :integer
    remove_column :retirement_firms, :registered_name, :string

    add_column :retirement_firms, :firm_id, :integer, references: :firm
  end
end
