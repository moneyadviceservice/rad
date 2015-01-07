class QuestionnaireStep1Form
  include ActiveModel::Model

  attr_accessor :firm_email_address,
                :firm_telephone_number,
                :main_office_line_1,
                :main_office_line_2,
                :main_office_town,
                :main_office_county,
                :main_office_postcode,
                :accept_customers_from

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

  validates :main_office_postcode,
            presence: true,
            format: {with: /\A[a-zA-Z\d]{1,4} [a-zA-Z\d]{1,3}\z/}

  validates :main_office_line_2,
            :main_office_town,
            :main_office_county,
            presence: true

  validates_inclusion_of :accept_customers_from, in: ->(form) { form.accept_customers_from_options }

  def accept_customers_from_options
    [
      'East of England',
      'East Midlands',
      'London',
      'North East',
      'North West',
      'South East',
      'South West',
      'West Midlands',
      'Yorkshire and the Humber',
      'Northern Ireland',
      'Scotland',
      'Wales',
      'All regions'
    ]
  end
end
