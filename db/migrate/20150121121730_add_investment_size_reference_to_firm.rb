class AddInvestmentSizeReferenceToFirm < ActiveRecord::Migration
  def change
    add_reference :firms, :investment_size, index: true
    add_foreign_key :firms, :investment_sizes
  end
end
