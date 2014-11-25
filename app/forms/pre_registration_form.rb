class PreRegistrationForm
  include ActiveModel::Model

  attr_accessor :question_1, :question_2, :question_3

  validates :question_1, :question_2, :question_3, inclusion: { in: %w{1} }
end
