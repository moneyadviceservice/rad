class FcaImportMailer < ApplicationMailer
  default from: 'RADenquiries@moneyadviceservice.org.uk'

  def notify(users, outcomes)
    @outcomes = outcomes || []
    mail(to: users, subject: 'Automated FCA Import Confirmation')
  end
end
