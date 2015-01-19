class AdminContact < ActionMailer::Base
  default(
    from: 'RADenquiries@moneyadviceservice.org.uk',
    to: 'RADenquiries@moneyadviceservice.org.uk'
  )

  def contact(email, message)
    @email, @message = email, message
    mail subject: 'IFA Contact'
  end
end
