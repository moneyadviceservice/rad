class PreQualificationForm
  include ActiveModel::Model

  attr_accessor :firm_active_question, :firm_business_model_question, :firm_status_question, :firm_particular_market_question

  validates :firm_active_question, :firm_business_model_question, acceptance: true, presence: true

  validates :firm_status_question, inclusion: { in: %w(0 1) }

  validates :firm_particular_market_question, presence: true, acceptance: true, if: -> { self.restricted? }

  def restricted?
    firm_status_question == '0'
  end
end
