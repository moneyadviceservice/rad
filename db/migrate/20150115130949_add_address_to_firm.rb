class AddAddressToFirm < ActiveRecord::Migration
  def change
    add_column :firms, :address_line_1, :string, null: false
    add_column :firms, :address_line_2, :string, null: false
    add_column :firms, :address_town, :string, null: false
    add_column :firms, :address_county, :string, null: false
    add_column :firms, :address_postcode, :string, null: false
  end
end
