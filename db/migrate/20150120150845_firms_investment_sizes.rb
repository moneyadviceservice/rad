class FirmsInvestmentSizes < ActiveRecord::Migration
  def change
    create_table :firms_investment_sizes, id: false do |t|
      t.belongs_to :firm, index: true
      t.belongs_to :investment_size, index: true
    end
  end
end
