class TravelInsurance::RiskProfileForm
  include ActiveModel::Model

  attr_accessor :covered_by_ombudsman_question,
                :risk_profile_approach_question

  validates :covered_by_ombudsman_question,
            inclusion: { in: %w[0 1], message: '%{value} is required' }

  validates :risk_profile_approach_question,
            inclusion: { in: %w[bespoke questionaire neither], message: '%{value} is required' }

  def reject?
    covered_by_ombudsman_question == '0' || risk_profile_approach_question == 'neither'
  end

  def complete?
    !reject? && risk_profile_approach_question == 'bespoke'
  end
end
