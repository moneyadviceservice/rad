class AddReregisterApprovedAtToTravelInsuranceFirms < ActiveRecord::Migration[6.1]
  def change
    add_column :travel_insurance_firms, :reregister_approved_at, :timestamp
  end
end
