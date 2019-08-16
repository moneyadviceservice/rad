class FcaImportMailer < ApplicationMailer
  helper_method :protect_against_forgery?

  def notify(users, text)
    @text = text
    mail(to: users, subject: 'Automated FCA Import Notification')
  end

  protected

  def protect_against_forgery?
    false
  end
end
