class CreateFcaImports < ActiveRecord::Migration
  def change
    create_table :fca_imports do |t|
      t.string :files, null: false
      t.boolean :confirmed, default: false
      t.boolean :cancelled, default: false
      t.text :result, null: false
      t.timestamps null: false
    end
  end
end
