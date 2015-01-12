class QuestionnaireStepOneForm
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
                :free_initial_meeting,
                :initial_meeting_duration,
                :initial_advice_fee_structure,
                :ongoing_advice_fee_structure,
                :allow_customers_to_pay_for_advice,
                :minimum_fixed_one_off_fee_amount

  validates :firm_email_address,
            presence: true,
            length: { maximum: 50 },
            format: { with: /.+@.+\..+/ }

  validates :firm_telephone_number,
            presence: true,
            length: { maximum: 30},
            format: { with: /\A[0-9 ]+\z/ }

  validates :main_office_line_1,
            presence: true,
            length: { maximum: 100 }

  validates :main_office_postcode,
            presence: true,
            format: { with: /\A[a-zA-Z\d]{1,4} [a-zA-Z\d]{1,3}\z/ }

  validates :main_office_line_2,
            :main_office_town,
            :main_office_county,
            presence: true

  validate :accept_customers_from_list_is_valid
  validate :advice_in_person_list_is_valid
  validate :advice_by_other_methods_list_is_valid
  validate :free_initial_meeting_choice_is_valid
  validate :initial_meeting_duration_choice_is_valid
  validate :initial_advice_fee_structure_choice_is_valid
  validate :ongoing_advice_fee_structure_choice_is_valid
  validate :allow_customers_to_pay_for_advice_choice_is_valid

  def accept_customers_from_options
    @accept_customers_from_options ||=
        I18n.t('questionnaire.step_one.accept_customers_from.items').map {|item| item[:text] }
  end

  def advice_in_person_options
    @advice_in_person_options ||=
        I18n.t('questionnaire.step_one.in_person_advice.items').map {|item| item[:text] }
  end

  def advice_by_other_methods_options
    @advice_by_other_methods_options ||=
        I18n.t('questionnaire.step_one.other_methods_of_advice.items').map {|item| item[:text] }
  end

  def free_initial_meeting_options
    @free_initial_meeting_options ||= ['Yes', 'No']
  end

  def initial_meeting_duration_options
    @initial_meeting_duration_options ||=
        I18n.t('questionnaire.step_one.initial_meeting.items').map {|item| item[:text] }
  end

  def initial_advice_fee_structure_options
    @initial_advice_fee_structure_options ||=
        I18n.t('questionnaire.step_one.initial_advice_fee.items').map {|item| item[:text] }
  end

  def ongoing_advice_fee_structure_options
    @ongoing_advice_fee_structure_options ||=
        I18n.t('questionnaire.step_one.ongoing_advice_fee.items').map {|item| item[:text] }
  end

  def allow_customers_to_pay_for_advice_options
    @allow_customers_to_pay_for_advice_options ||=
        I18n.t('questionnaire.step_one.payment_methods.items').map {|item| item[:text] }
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

  def initial_meeting_duration_choice_is_valid
    if initial_meeting_duration
      unless initial_meeting_duration_options.include?(initial_meeting_duration)
        errors.add(:initial_meeting_duration, :invalid)
      end
    end
  end

  def initial_advice_fee_structure_choice_is_valid
    if initial_advice_fee_structure.nil?
      errors.add(:initial_advice_fee_structure, :required)
    else
      unless initial_advice_fee_structure_options.include?(initial_advice_fee_structure)
        errors.add(:initial_advice_fee_structure, :invalid)
      end
    end
  end

  def ongoing_advice_fee_structure_choice_is_valid
    if ongoing_advice_fee_structure.nil?
      errors.add(:ongoing_advice_fee_structure, :required)
    else
      unless ongoing_advice_fee_structure_options.include?(ongoing_advice_fee_structure)
        errors.add(:ongoing_advice_fee_structure, :invalid)
      end
    end
  end

  def allow_customers_to_pay_for_advice_choice_is_valid
    if allow_customers_to_pay_for_advice.nil?
      errors.add(:allow_customers_to_pay_for_advice, :required)
    else
      unless allow_customers_to_pay_for_advice_options.include?(allow_customers_to_pay_for_advice)
        errors.add(:allow_customers_to_pay_for_advice, :invalid)
      end
    end
  end

  def array_contains_values?(array, values)
    values and (values.uniq - array.uniq).empty?
  end
end
