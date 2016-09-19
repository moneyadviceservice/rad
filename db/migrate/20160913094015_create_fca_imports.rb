class CreateFcaImports < ActiveRecord::Migration
  def change
    create_table :fca_imports do |t|
      t.string :files, null: false
      t.string :status
      t.text :result
      t.timestamps null: false
    end
  end
end
