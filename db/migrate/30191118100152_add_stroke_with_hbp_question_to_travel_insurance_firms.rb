class AddStrokeWithHbpQuestionToTravelInsuranceFirms < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_insurance_firms, :stroke_with_hbp_question, :boolean
  end
end
