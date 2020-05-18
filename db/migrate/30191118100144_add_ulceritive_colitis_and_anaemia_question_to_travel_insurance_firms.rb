class AddUlceritiveColitisAndAnaemiaQuestionToTravelInsuranceFirms < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_insurance_firms, :ulceritive_colitis_and_anaemia_question, :string
  end
end
