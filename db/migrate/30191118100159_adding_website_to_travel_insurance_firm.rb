class AddingWebsiteToTravelInsuranceFirm < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_insurance_firms, :website_address, :text
  end
end
