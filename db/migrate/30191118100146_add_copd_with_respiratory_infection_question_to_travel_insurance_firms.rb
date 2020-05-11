class AddCopdWithRespiratoryInfectionQuestionToTravelInsuranceFirms < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_insurance_firms, :copd_with_respiratory_infection_question, :string
  end
end
