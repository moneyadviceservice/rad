class TravelInsurance::RiskProfileForm
  include ActiveModel::Model

  attr_accessor :covered_by_ombudsman_question,
                :risk_profile_approach_question,
                :supplies_documentation_when_needed_question

  validates :covered_by_ombudsman_question,
            inclusion: { in: %w[true false], message: '%{value} is required' }

  validates :risk_profile_approach_question,
            inclusion: { in: %w[bespoke questionaire non-proprietary neither], message: '%{value} is required' }

  validates :supplies_documentation_when_needed_question,
            inclusion: { in: %w[true false], message: '%{value} is required' }
end
