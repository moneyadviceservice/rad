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

  validate :accept_customers_from_list_is_valid

  def accept_customers_from_options
    @accept_customers_from_options ||=
        I18n.t('questionnaire.step_one.section_four.regions').map {|item| item[:region] }
  end

  private

  def accept_customers_from_list_is_valid
    if accept_customers_from.nil? or accept_customers_from.empty?
      errors.add(:accept_customers_from, :required)
    else
      unless array_contains_values?(accept_customers_from_options, accept_customers_from)
        errors.add(:accept_customers_from, :invalid)
      end
    end
  end

  def array_contains_values?(array, values)
    (values.uniq - array.uniq).empty?
  end
end
