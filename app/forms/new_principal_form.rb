class NewPrincipalForm
  include ActiveModel::Model

  PRINCIPAL_PARAMS = %i[
    fca_number first_name last_name individual_reference_number job_title email_address
    telephone_number confirmed_disclaimer
  ].freeze
  USER_PARAMS = %i[email password password_confirmation].freeze
  PARAMS = PRINCIPAL_PARAMS | USER_PARAMS | %i[registration_type]
  attr_accessor(*PARAMS)
  alias email_address email

  def initialize(attributes = {})
    super(attributes)
    self.email = email&.downcase
    self.email_address = email_address&.downcase
  end

  validate do
    user = validated_user
    validate_fca_number
    validate_individual_reference_number

    PARAMS.each do |param|
      user.errors[param].each do |error|
        add_deduplicated_error(param, error)
      end

      user.principal.errors[param].each do |error|
        add_deduplicated_error(param, error)
      end
    end
  end

  def principal_params
    PRINCIPAL_PARAMS.inject({}) do |principal_params, param_name|
      principal_params.update(param_name => send(param_name))
    end.merge(travel_insurance_principal: travel_insurance_registration?)
  end

  def user_params
    USER_PARAMS.inject({}) do |user_params, param_name|
      user_params.update(param_name => send(param_name))
    end
  end

  def field_order
    %i[
      fca_number
      first_name
      last_name
      individual_reference_number
      job_title
      email
      telephone_number
      password
      password_confirmation
      confirmed_disclaimer
    ]
  end

  def individual_reference_number
    @individual_reference_number.to_s
  end

  private

  def validated_user
    User.new(user_params).tap do |user|
      user.build_principal(principal_params)
      user.validate
    end
  end

  def validate_fca_number
    response = Rails.cache.fetch(['registration_fca_number', fca_number], expires_in: 1.hour) do
      response = FcaApi::Request.new.get_firm(fca_number)
      raise 'firm not found' unless response.ok?

      response.ok?
    rescue RuntimeError
      false
    end

    errors.add(:fca_number, 'is invalid') unless response
  end

  def validate_individual_reference_number
    return unless travel_insurance_registration? && individual_reference_number.present?

    response = Rails.cache.fetch(['registration_individual_reference', individual_reference_number], expires_in: 1.hour) do
      response = FcaApi::Request.new.get_individual(individual_reference_number)
      response.ok?
    rescue RuntimeError
      false
    end

    errors.add(:individual_reference_number, 'is invalid') unless response
  end

  def travel_insurance_registration?
    registration_type == 'travel_insurance_registrations'
  end

  def add_deduplicated_error(param, error)
    if %i[email email_address].include?(param)
      return if errors[:email].include?(error)
      param = :email
    end
    errors.add(param, error)
  end
end
