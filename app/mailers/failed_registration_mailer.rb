class FailedRegistrationMailer < ActionMailer::Base
  def notify(email)
    mail(
      to: email,
      subject: 'Your Retirement Adviser Directory Registration'
    )
  end
end
