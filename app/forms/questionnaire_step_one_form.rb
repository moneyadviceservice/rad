class QuestionnaireStepOneForm
  include ActiveModel::Model

  attr_accessor :email_address,
                :telephone_number,
                :address_line_1,
                :address_line_2,
                :address_town,
                :address_county,
                :address_postcode,
                :accept_customers_from,
                :in_person_advice,
                :other_methods_of_advice,
                :initial_meeting,
                :initial_meeting_duration,
                :initial_advice_fee,
                :ongoing_advice_fee,
                :payment_methods,
                :minimum_fixed_fee

  validates :email_address,
            presence: true,
            length: { maximum: 50 },
            format: { with: /.+@.+\..+/ }

  validates :telephone_number,
            presence: true,
            length: { maximum: 30},
            format: { with: /\A[0-9 ]+\z/ }

  validates :address_line_1,
            presence: true,
            length: { maximum: 100 }

  validates :address_postcode,
            presence: true,
            format: { with: /\A[a-zA-Z\d]{1,4} [a-zA-Z\d]{1,3}\z/ }

  validates :address_line_2,
            :address_town,
            :address_county,
            presence: true

  validates :initial_meeting,
            presence: true,
            inclusion: { in: ->(form) { form.initial_meeting_options } }

  validates :initial_meeting_duration,
            allow_nil: true,
            inclusion: { in: ->(form) { form.initial_meeting_duration_options } }

  validates :initial_advice_fee,
            presence: true,
            inclusion: { in: ->(form) { form.initial_advice_fee_options } }

  validates :ongoing_advice_fee,
            presence: true,
            inclusion: { in: ->(form) { form.ongoing_advice_fee_options } }

  validates :payment_methods,
            presence: true,
            inclusion: { in: ->(form) { form.payment_methods_options } }

  validate :accept_customers_from_choices_are_valid
  validate :in_person_advice_choices_are_valid
  validate :other_methods_of_advice_choices_are_valid

  def accept_customers_from_options
    @accept_customers_from_options ||=
        I18n.t('questionnaire.step_one.accept_customers_from.items').map {|item| item[:text] }
  end

  def in_person_advice_options
    @advice_in_person_options ||=
        I18n.t('questionnaire.step_one.in_person_advice.items').map {|item| item[:text] }
  end

  def other_methods_of_advice_options
    @advice_by_other_methods_options ||=
        I18n.t('questionnaire.step_one.other_methods_of_advice.items').map {|item| item[:text] }
  end

  def initial_meeting_options
    @initial_meeting_options ||=
        I18n.t('questionnaire.step_one.initial_meeting.items').map {|item| item[:text] }
  end

  def initial_meeting_duration_options
    @initial_meeting_duration_options ||=
        I18n.t('questionnaire.step_one.initial_meeting_duration.items').map {|item| item[:text] }
  end

  def initial_advice_fee_options
    @initial_advice_fee_options ||=
        I18n.t('questionnaire.step_one.initial_advice_fee.items').map {|item| item[:text] }
  end

  def ongoing_advice_fee_options
    @ongoing_advice_fee_options ||=
        I18n.t('questionnaire.step_one.ongoing_advice_fee.items').map {|item| item[:text] }
  end

  def payment_methods_options
    @allow_customers_to_pay_for_advice_options ||=
        I18n.t('questionnaire.step_one.payment_methods.items').map {|item| item[:text] }
  end

  private

  def accept_customers_from_choices_are_valid
    if accept_customers_from.nil? or accept_customers_from.empty?
      errors.add(:accept_customers_from, :required)
    else
      unless array_contains_values?(accept_customers_from_options, accept_customers_from)
        errors.add(:accept_customers_from, :invalid)
      end
    end
  end

  def in_person_advice_choices_are_valid
    if in_person_advice.nil? or in_person_advice.empty?
      errors.add(:in_person_advice, :required)
    else
      unless array_contains_values?(in_person_advice_options, in_person_advice)
        errors.add(:in_person_advice, :invalid)
      end
    end
  end

  def other_methods_of_advice_choices_are_valid
    unless array_contains_values?(other_methods_of_advice_options, other_methods_of_advice)
      errors.add(:other_methods_of_advice, :invalid)
    end
  end

  def array_contains_values?(array, values)
    values and (values.uniq - array.uniq).empty?
  end
end
