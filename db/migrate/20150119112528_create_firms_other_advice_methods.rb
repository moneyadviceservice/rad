class CreateFirmsOtherAdviceMethods < ActiveRecord::Migration
  def change
    create_table :firms_other_advice_methods, id: false do |t|
      t.belongs_to :firm, index: true
      t.belongs_to :other_advice_method, index: true
    end
  end
end
