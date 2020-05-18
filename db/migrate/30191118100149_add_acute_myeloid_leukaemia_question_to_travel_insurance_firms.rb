class AddAcuteMyeloidLeukaemiaQuestionToTravelInsuranceFirms < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_insurance_firms, :acute_myeloid_leukaemia_question, :string
  end
end
