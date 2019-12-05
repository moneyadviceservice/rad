class RemoveForeignKeyFromInactiveFirms < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :inactive_firms, :firms
  end
end
