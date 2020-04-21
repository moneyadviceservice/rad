class TravelInsurance::MedicalConditionsForm
  include ActiveModel::Model

  attr_accessor :covers_medical_condition_question

  validates :covers_medical_condition_question,
            inclusion: { in: %w[all one_specific] }


  def complete?
    covers_medical_condition_question == 'one_specific'
  end

  def reject?
    false
  end
end
