class AddSubArachnoidHaemorrhageAndEpilepsyQuestionToTravelInsuranceFirms < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_insurance_firms, :sub_arachnoid_haemorrhage_and_epilepsy_question, :string
  end
end
