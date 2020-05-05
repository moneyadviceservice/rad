class AddCoversMedicalConditionQuestionToTravelInsuranceFirms < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_insurance_firms, :covers_medical_condition_question, :string
  end
end
