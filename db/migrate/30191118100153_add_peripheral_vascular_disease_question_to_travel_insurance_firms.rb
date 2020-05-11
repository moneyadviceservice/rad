class AddPeripheralVascularDiseaseQuestionToTravelInsuranceFirms < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_insurance_firms, :peripheral_vascular_disease_question, :string
  end
end
