class CreateServiceRegions < ActiveRecord::Migration
  def change
    create_table :service_regions do |t|
      t.string :name, null: false
      t.index :name, unique: true

      t.timestamps null: false
    end
  end
end
