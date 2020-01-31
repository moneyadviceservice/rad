class VerifiedPrincipal
  attr_accessor :form, :firm_name

  def initialize(form_data, firm_name)
    @form = NewPrincipalForm.new(form_data)
    @firm_name = firm_name
  end

  def register!
    create_new_principal
    firm = create_associated_firm
    send_notifications(firm)
  end

  private

  def create_new_principal
    @user = User.new(form.user_params)
    @user.build_principal(form.principal_params)
    @user.save!
    Stats.increment('radsignup.principal.created')
  end

  def create_associated_firm
    case form.registration_type
    when 'travel_insurance_registrations'
      TravelInsuranceFirm.create(
        fca_number: form.fca_number,
        registered_name: firm_name
      )
    when 'retirement_advice_registrations'
      Firm.create(
        fca_number: form.fca_number,
        registered_name: firm_name
      )
    else
      raise error_message
    end
  end

  def error_message
    "Unsupported registration_type [#{form.registration_type}] when creating new principal"
  end

  def send_notifications(firm)
    SuccessfulRegistrationMailer.contact(@user.principal, form.registration_type).deliver_later
    NewFirmMailer.notify(firm).deliver_later
  end
end
