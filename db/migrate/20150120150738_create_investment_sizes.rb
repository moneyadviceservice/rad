class CreateInvestmentSizes < ActiveRecord::Migration
  def change
    create_table :investment_sizes do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
