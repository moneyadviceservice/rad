class DowncaseAllPrincipalEmailAddresses < ActiveRecord::Migration[5.2]
  def up
    Principal.find_in_batches do |batch|
      batch.each do |principal|
        principal.update(email_address: principal.email_address.downcase)
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
