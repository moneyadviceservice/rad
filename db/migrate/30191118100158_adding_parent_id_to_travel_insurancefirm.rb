class AddingParentIdToTravelInsurancefirm < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_insurance_firms, :parent_id, :integer
  end
end
