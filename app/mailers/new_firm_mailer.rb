class NewFirmMailer < ActionMailer::Base
  def notify(firm)
    @firm = firm
    mail(to: email_recipients,
         subject: 'New Firm registered in the directory')
  end

  private

  def email_recipients
    if @firm.is_a?(TravelInsuranceFirm)
      ENV['TAD_ADMIN_EMAIL']
    else
      FCA::Config.email_recipients
    end
  end
end
