class AddHeartAttackWithHbpAndHighCholesterolQuestionToTravelInsuranceFirms < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_insurance_firms, :heart_attack_with_hbp_and_high_cholesterol_question, :string
  end
end
