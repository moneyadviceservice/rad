class PreQualificationForm
  include ActiveModel::Model

  attr_accessor :active_question,
    :business_model_question,
    :status_question,
    :particular_market_question,
    :consider_available_providers_question

  validates :active_question, :business_model_question,
    acceptance: true,
    presence: true

  validates :status_question, inclusion: { in: %w(0 1) }

  validates :particular_market_question,
    presence: true,
    acceptance: true,
    if: -> { self.restricted? }

  validates :consider_available_providers_question,
    presence: true,
    acceptance: true,
    if: -> { self.must_consider_available_providers? }

  def restricted?
    status_question == '0'
  end

  def focused_on_particular_markets?
    particular_market_question == '1'
  end

  def must_consider_available_providers?
    restricted? && focused_on_particular_markets?
  end
end
