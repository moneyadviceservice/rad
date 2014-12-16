class AdminContact < ActionMailer::Base
  def contact(email, message)
    @email, @message = email, message
    mail(
      to: 'IFADirectoryQueries@moneyadviceservice.org.uk',
      subject: 'IFA Contact'
    )
  end
end
