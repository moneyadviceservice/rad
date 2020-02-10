class PrincipalRegistrationStatus
  def initialize(email, registration_type)
    @email = email
    @registration_type = registration_type
  end

  def already_signed_up_for_this_service?
    principal && principal.send(firm_method).present?
  end

  def existing_principal?
    principal.present?
  end

  private

  def principal
    @principal ||= Principal.find_by(email_address: @email)
  end

  def firm_method
    DirectoryRegistrationService::REGISTRATION_TYPE_TO_FIRM_MAPPING.fetch(
      @registration_type
    )
  end
end
