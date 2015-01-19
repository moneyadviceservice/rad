class PreQualificationForm
  include ActiveModel::Model

  attr_accessor :question_1, :question_2, :question_3, :question_4, :question_5

  validates :question_1, :question_2, :question_3, acceptance: true, presence: true

  validates :question_4, inclusion: { in: %w(0 1) }

  validates :question_5, presence: true, acceptance: true, if: -> { self.restricted? }

  def restricted?
    question_4 == '0'
  end
end
