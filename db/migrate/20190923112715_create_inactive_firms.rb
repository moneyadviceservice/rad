class CreateInactiveFirms < ActiveRecord::Migration
  def change
    create_table :inactive_firms do |t|
      t.references :firm, index: true, foreign_key: true
      t.string :api_status

      t.timestamps null: false
    end
  end
end
