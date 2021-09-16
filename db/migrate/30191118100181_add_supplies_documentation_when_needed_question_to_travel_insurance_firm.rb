class AddSuppliesDocumentationWhenNeededQuestionToTravelInsuranceFirm < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_insurance_firms, :supplies_documentation_when_needed_question, :string
  end
end
