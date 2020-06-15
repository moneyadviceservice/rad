class AddSchizophreniaQuestionToTravelInsuranceFirms < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_insurance_firms, :schizophrenia_question, :string
  end
end
