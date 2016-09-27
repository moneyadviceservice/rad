class FcaImportMailer < ApplicationMailer
  default from: 'RADenquiries@moneyadviceservice.org.uk'
  helper_method :protect_against_forgery?

  def notify(users, outcomes)
    @outcomes = outcomes || []
    mail(to: users, subject: 'Automated FCA Import Confirmation')
  end

  protected

  def protect_against_forgery?
    false
  end
end
