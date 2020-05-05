class AddMotorNeuroneDiseaseQuestionToTravelInsuranceFirms < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_insurance_firms, :motor_neurone_disease_question, :boolean
  end
end
