class AddConfirmedDisclaimerToTravelInsuranceFirms < ActiveRecord::Migration[6.1]
  def change
    add_column :travel_insurance_firms, :confirmed_disclaimer, :boolean, null: false, default: false
  end
end
