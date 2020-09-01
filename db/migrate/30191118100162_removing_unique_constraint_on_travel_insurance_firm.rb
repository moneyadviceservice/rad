class RemovingUniqueConstraintOnTravelInsuranceFirm < ActiveRecord::Migration[5.2]
  def change
    remove_index :travel_insurance_firms, :fca_number
    add_index :travel_insurance_firms, :fca_number
  end
end
