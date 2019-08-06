class VerifiedPrincipal
  attr_accessor :form

  def initialize(form)
    @form = form
  end

  def register!
    firm_name = VerifyFrnJob.perform_async(form.fca_number)
    
    if firm_name
      principal = create_new_principal
      principal.firm = create_associate_firm(firm_name)
      send_notifications
    else
      send_fail_email
    end
  end

  private
  
  def create_new_principal
    @user = User.new(form.user_params)
    @user.build_principal(form.principal_params)
    @user.save!

    Stats.increment('radsignup.principal.created')
  end

  def create_associate_firm(firm_name)
    Firm.new(fca_number: form.fca_number,
             registered_name: firm_name).tap do |f|
      f.save!(validate: false)
    end
  end

  def send_notifications
    Identification.contact(@user.principal).deliver_later
    NewFirmMailer.notify(@user.principal.firm).deliver_later
  end

  def send_fail_email
    email_address = form.user_params[:email]
    FailedRegistrationMailer.notify(email_address).deliver_later
  end
end
