class DropFirmsInvestmentSizes < ActiveRecord::Migration
  def change
    drop_table :firms_investment_sizes
  end
end
