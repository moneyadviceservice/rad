class AddBusinessIncomeBreakdownFieldsToFirm < ActiveRecord::Migration
  def change
    add_column :firms, :retirement_income_products_percent, :integer, null: false
    add_column :firms, :pension_transfer_percent, :integer, null: false
    add_column :firms, :long_term_care_percent, :integer, null: false
    add_column :firms, :equity_release_percent, :integer, null: false
    add_column :firms, :inheritance_tax_and_estate_planning_percent, :integer, null: false
    add_column :firms, :wills_and_probate_percent, :integer, null: false
    add_column :firms, :other_percent, :integer, null: false
  end
end
