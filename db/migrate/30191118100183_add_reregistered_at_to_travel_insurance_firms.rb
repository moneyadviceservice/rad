class AddReregisteredAtToTravelInsuranceFirms < ActiveRecord::Migration[6.1]
  def change
    add_column :travel_insurance_firms, :reregistered_at, :datetime
  end
end
