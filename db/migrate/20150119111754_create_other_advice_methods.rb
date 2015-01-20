class CreateOtherAdviceMethods < ActiveRecord::Migration
  def change
    create_table :other_advice_methods do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
