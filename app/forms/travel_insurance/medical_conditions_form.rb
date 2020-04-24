class TravelInsurance::MedicalConditionsForm
  include ActiveModel::Model

  attr_accessor :covers_medical_condition_question

  validates :covers_medical_condition_question,
            inclusion: { in: %w[all one_specific] }
end
