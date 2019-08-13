class NewFirmMailer < ActionMailer::Base
  def notify(firm)
    @firm = firm
    mail(to: FCA::Config.email_recipients,
         subject: 'New Firm registered in the directory')
  end
end
