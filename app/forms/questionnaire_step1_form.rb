class QuestionnaireStep1Form
  include ActiveModel::Model

  attr_accessor :firm_email_address

  validates :firm_email_address,
            presence: true,
            length: {maximum: 50},
            format: {with: /.+@.+\..+/}
end
