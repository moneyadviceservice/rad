class AddPrincipalIdToUser < ActiveRecord::Migration
  def change
    add_column(:users, :principal_token, :string)
  end
end
