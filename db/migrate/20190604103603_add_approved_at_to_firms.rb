class AddApprovedAtToFirms < ActiveRecord::Migration
  def up
    add_column :firms, :approved_at, :datetime
    add_index :firms, :approved_at

    db.execute "UPDATE firms SET approved_at = current_timestamp"
  end

  def down
    remove_column :firms, :approved_at
  end

  private

  def db
    ActiveRecord::Base.connection
  end
end
