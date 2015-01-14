class CreateFirms < ActiveRecord::Migration
  def change
    create_table :firms do |t|
      t.string :email_address, null: false
      t.string :telephone_number, null: false

      t.timestamps null: false
    end
  end
end
