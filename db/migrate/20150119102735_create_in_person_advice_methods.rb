class CreateInPersonAdviceMethods < ActiveRecord::Migration
  def change
    create_table :in_person_advice_methods do |t|
      t.string :name, null: false, index: true

      t.timestamps null: false
    end
  end
end
