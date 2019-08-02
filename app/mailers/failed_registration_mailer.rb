class FailedRegistrationMailer < ActionMailer::Base
  default from: 'RADenquiries@moneyadviceservice.org.uk'

  def notify(email)
    mail(
      to: email,
      subject: 'Your Retirement Adviser Directory Registration'
    )
  end
end
