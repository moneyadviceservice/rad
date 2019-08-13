class VerifiedPrincipal
  attr_accessor :form, :firm_name

  def initialize(form_data, firm_name)
    @form = NewPrincipalForm.new(form_data)
    @firm_name = firm_name
  end

  def register!
    create_new_principal
    create_associate_firm
    send_notifications
  end

  private
  
  def create_new_principal
    @user = User.new(form.user_params)
    @user.build_principal(form.principal_params)
    @user.save!
    Stats.increment('radsignup.principal.created')
  end

  def create_associate_firm
    Firm.new(fca_number: form.fca_number,
             registered_name: firm_name).tap do |f|
      f.save!(validate: false)
    end
  end

  def send_notifications
    Identification.contact(@user.principal).deliver_later
    NewFirmMailer.notify(@user.principal.firm).deliver_later
  end
end
