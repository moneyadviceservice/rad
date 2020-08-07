class AddingSeniorManagerNameToPrincipal < ActiveRecord::Migration[5.2]
  def change
    add_column :principals, :senior_manager_name, :text
  end
end
