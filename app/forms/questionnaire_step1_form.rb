class QuestionnaireStep1Form
  include ActiveModel::Model

  attr_accessor :firm_email_address, :firm_telephone_number, :main_office_line_1, :main_office_line_2

  validates :firm_email_address,
            presence: true,
            length: {maximum: 50},
            format: {with: /.+@.+\..+/}

  validates :firm_telephone_number,
            presence: true,
            length: {maximum: 30},
            format: {with: /\A[0-9 ]+\z/}

  validates :main_office_line_1,
            presence: true,
            length: {maximum: 100}

  validates :main_office_line_2,
            presence: true
end
