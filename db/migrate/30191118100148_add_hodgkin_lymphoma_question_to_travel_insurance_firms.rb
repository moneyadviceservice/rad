class AddHodgkinLymphomaQuestionToTravelInsuranceFirms < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_insurance_firms, :hodgkin_lymphoma_question, :string
  end
end
