class AddHeartFailureAndArrhytmiaQuestionToTravelInsuranceFirms < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_insurance_firms, :heart_failure_and_arrhytmia_question, :boolean
  end
end
