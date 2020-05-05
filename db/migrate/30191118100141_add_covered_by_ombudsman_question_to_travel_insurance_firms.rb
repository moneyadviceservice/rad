class AddCoveredByOmbudsmanQuestionToTravelInsuranceFirms < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_insurance_firms, :covered_by_ombudsman_question, :boolean
  end
end
