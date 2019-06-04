class NewFirmMailer < ActionMailer::Base
  default(
    from: 'RADenquiries@moneyadviceservice.org.uk',
    to: 'RADenquiries@moneyadviceservice.org.uk'
  )

  def notify(firm)
    @firm = firm
    mail(to: FCA::Config.email_recipients,
         subject: 'New Firm registered in the directory')
  end
end
