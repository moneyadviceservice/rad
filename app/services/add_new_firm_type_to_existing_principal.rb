class AddNewFirmTypeToExistingPrincipal
  def self.call(form)
    new(form).call
  end

  attr_accessor :form

  def initialize(form)
    @form = form
  end

  def call
    new_firm = principal.send(create_method, existing_firm_attributes)
    SuccessfulRegistrationMailer.contact(principal, form.registration_type).deliver_later
    NewFirmMailer.notify(new_firm).deliver_later
  end

  private

  def user
    User.find_by(email: form.email)
  end

  def principal
    @principal ||= user.principal
  end

  def existing_firm
    principal.firm || principal.travel_insurance_firm
  end

  def create_method
    firm_type =
      DirectoryRegistrationService::REGISTRATION_TYPE_TO_FIRM_MAPPING.fetch(
        form.registration_type
      )
    "create_#{firm_type}"
  end

  def existing_firm_attributes
    existing_firm.attributes.slice('fca_number', 'registered_name')
  end
end
