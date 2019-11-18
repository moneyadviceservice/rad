class VerifiedPrincipal
  attr_accessor :form, :firm_name

  def initialize(form_data, firm_name)
    @form = NewPrincipalForm.new(form_data)
    @firm_name = firm_name
  end

  def register!
    create_new_principal
    create_associate_firm do |firm|
      send_notifications(firm)
    end
  end

  private

  def create_new_principal
    @user = User.new(form.user_params)
    @user.build_principal(form.principal_params)
    @user.save!
    Stats.increment('radsignup.principal.created')
  end

  def create_associate_firm
    firm = if form.registration_type == 'travel_insurance_registrations'
      TravelInsuranceFirm.new(fca_number: form.fca_number,
                              registered_name: firm_name).tap do |f|
        f.save!(validate: false)
      end
    else
      Firm.new(fca_number: form.fca_number,
               registered_name: firm_name).tap do |f|
        f.save!(validate: false)
      end
    end

    yield firm
  end

  def send_notifications(firm)
    Identification.contact(@user.principal).deliver_later
    NewFirmMailer.notify(firm).deliver_later
  end
end
