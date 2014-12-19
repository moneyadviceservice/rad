class AdminContact < ActionMailer::Base
  default(
    from: 'IFADirectoryQueries@moneyadviceservice.org.uk',
    to: 'IFADirectoryQueries@moneyadviceservice.org.uk'
  )

  def contact(email, message)
    @email, @message = email, message
    mail subject: 'IFA Contact'
  end
end
