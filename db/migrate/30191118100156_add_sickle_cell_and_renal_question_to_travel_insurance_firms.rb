class AddSickleCellAndRenalQuestionToTravelInsuranceFirms < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_insurance_firms, :sickle_cell_and_renal_question, :string
  end
end
