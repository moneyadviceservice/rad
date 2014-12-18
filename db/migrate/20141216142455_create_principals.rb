class CreatePrincipals < ActiveRecord::Migration
  def change
    create_table :principals do |t|
      t.string  :token, null: false, limit: 32
      t.index :token, unique: true
      t.datetime :last_sign_in_at

      t.timestamps
    end
  end
end
