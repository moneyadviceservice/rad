class AddFcaVerifiedToPrincipals < ActiveRecord::Migration
  def up
    add_column :principals, :fca_verified, :boolean, default: false
    add_index :principals, :fca_verified

    db.execute "UPDATE principals SET fca_verified = true"
  end

  def down
    remove_column :principals, :fca_verified
  end

  private

  def db
    ActiveRecord::Base.connection
  end
end
