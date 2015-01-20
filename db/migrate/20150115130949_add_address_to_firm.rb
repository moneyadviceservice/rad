class AddAddressToFirm < ActiveRecord::Migration
  def change
    add_column :firms, :address_line_1, :string
    add_column :firms, :address_line_2, :string
    add_column :firms, :address_town, :string
    add_column :firms, :address_county, :string
    add_column :firms, :address_postcode, :string
  end
end
