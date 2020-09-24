class AddFirmableToInactiveFirms < ActiveRecord::Migration[5.2]
  def change
    add_reference :inactive_firms, :firmable, polymorphic: true
  end
end
