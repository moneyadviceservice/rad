class QuestionnaireStep1Form
  include ActiveModel::Model

  attr_accessor :firm_email_address,
                :firm_telephone_number,
                :main_office_line_1,
                :main_office_line_2,
                :main_office_town,
                :main_office_county,
                :main_office_postcode,
                :accept_customers_from,
                :advice_in_person,
                :advice_by_other_methods,
                :free_initial_meeting

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
  validate :advice_in_person_list_is_valid
  validate :advice_by_other_methods_list_is_valid
  validate :free_initial_meeting_choice_is_valid

  def accept_customers_from_options
    @accept_customers_from_options ||=
        I18n.t('questionnaire.step_one.section_four.regions').map {|item| item[:region] }
  end

  def advice_in_person_options
    @advice_in_person_options ||=
        I18n.t('questionnaire.step_one.section_five.regions').map {|item| item[:region] }
  end

  def advice_by_other_methods_options
    @advice_by_other_methods_options ||=
        I18n.t('questionnaire.step_one.section_five.advice_options').map {|item| item[:advice] }
  end

  def free_initial_meeting_options
    @free_initial_meeting_options ||= ['Yes', 'No']
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

  def advice_in_person_list_is_valid
    if advice_in_person.nil? or advice_in_person.empty?
      errors.add(:advice_in_person, :required)
    else
      unless array_contains_values?(advice_in_person_options, advice_in_person)
        errors.add(:advice_in_person, :invalid)
      end
    end
  end

  def advice_by_other_methods_list_is_valid
    unless array_contains_values?(advice_by_other_methods_options, advice_by_other_methods)
      errors.add(:advice_by_other_methods, :invalid)
    end
  end

  def free_initial_meeting_choice_is_valid
    if free_initial_meeting.nil?
      errors.add(:free_initial_meeting, :required)
    else
      unless free_initial_meeting_options.include?(free_initial_meeting)
        errors.add(:free_initial_meeting, :invalid)
      end
    end
  end

  def array_contains_values?(array, values)
    values and (values.uniq - array.uniq).empty?
  end
end
