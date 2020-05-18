class AddMetastaticBreastCancerQuestionToTravelInsuranceFirms < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_insurance_firms, :metastatic_breast_cancer_question, :string
  end
end
