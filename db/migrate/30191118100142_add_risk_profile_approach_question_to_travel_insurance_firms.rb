class AddRiskProfileApproachQuestionToTravelInsuranceFirms < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_insurance_firms, :risk_profile_approach_question, :string
  end
end
