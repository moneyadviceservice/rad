class PreQualificationForm
  include ActiveModel::Model

  attr_accessor :question_1, :question_2, :question_3, :question_4, :question_5

  validates :question_1, :question_2, :question_3, inclusion: { in: ['1'] }

  validates :question_4, inclusion: { in: ['0', '1'] }

  validates :question_5, inclusion: { in: ['1'] }, if: -> { self.restricted? }

  def restricted?
    question_4 == '0'
  end
end
