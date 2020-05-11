class TravelInsurance::RiskProfileForm
  include ActiveModel::Model

  attr_accessor :covered_by_ombudsman_question,
                :risk_profile_approach_question

  validates :covered_by_ombudsman_question,
            inclusion: { in: %w[true false], message: '%{value} is required' }

  validates :risk_profile_approach_question,
            inclusion: { in: %w[bespoke questionaire neither], message: '%{value} is required' }
end
