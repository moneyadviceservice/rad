class PreQualificationForm
  include ActiveModel::Model

  attr_accessor :question_1, :question_2, :question_3, :question_4, :question_5

  validates :question_1, :question_2, :question_3, :question_5, inclusion: { in: %w{1} }
end
