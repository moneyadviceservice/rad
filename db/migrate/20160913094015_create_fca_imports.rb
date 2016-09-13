class CreateFcaImports < ActiveRecord::Migration
  def change
    create_table :fca_imports do |t|
      t.boolean :confirmed, default: false
      t.boolean :cancelled, default: false
      t.text :result, null: false
      t.timestamps null: false
    end
  end
end
