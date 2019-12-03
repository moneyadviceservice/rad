class DirectoryRegistrationService
  REGISTRATION_TYPE_TO_FIRM_MAPPING = {
    retirement_advice_registrations: :firm,
    travel_insurance_registrations: :travel_insurance_firm
  }.with_indifferent_access

  def self.call(form)
    new(form).call
  end

  attr_accessor :form, :registration_status

  def initialize(form)
    @form = form
    @registration_status = PrincipalRegistrationStatus.new(
      form.email,
      form.registration_type
    )
  end

  def call
    if already_signed_up_for_this_service?
      form.validate
      return failure
    end

    if existing_principal?
      AddNewFirmTypeToExistingPrincipal.call(form)
      return success
    elsif form.valid?
      VerifyReferenceNumberJob.perform_later(registration_data)
      return success
    else
      return failure
    end
  end

  def success
    OpenStruct.new(success?: true)
  end

  def failure
    OpenStruct.new(success?: false, form: form)
  end

  private

  def registration_data
    required_fields = %w[
      fca_number
      first_name
      last_name
      job_title
      email
      telephone_number
      password
      password_confirmation
      confirmed_disclaimer
      registration_type
    ]
    form.as_json.slice(*required_fields)
  end

  def already_signed_up_for_this_service?
    registration_status.already_signed_up_for_this_service?
  end

  def existing_principal?
    registration_status.existing_principal?
  end
end
