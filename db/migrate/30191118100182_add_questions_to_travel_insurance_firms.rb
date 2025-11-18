class AddQuestionsToTravelInsuranceFirms < ActiveRecord::Migration[6.1]
  def change
    add_column :travel_insurance_firms, :prostate_cancer_question, :string
    add_column :travel_insurance_firms, :type_one_diabetes_question, :string
    add_column :travel_insurance_firms, :parkinsons_disease_question, :string
    add_column :travel_insurance_firms, :hiv_question, :string
  end
end
