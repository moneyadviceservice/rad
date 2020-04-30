class CreatePolymorphicFirms < ActiveRecord::Migration[5.2]
  def change
    create_table :firms do |t|
      t.integer :fca_number, null: false
      t.integer 'parent_id'
      t.timestamps null: false

      t.index :fca_number, unique: true
    end
  end
end
