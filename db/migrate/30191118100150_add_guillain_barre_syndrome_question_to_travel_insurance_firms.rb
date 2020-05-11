class AddGuillainBarreSyndromeQuestionToTravelInsuranceFirms < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_insurance_firms, :guillain_barre_syndrome_question, :string
  end
end
