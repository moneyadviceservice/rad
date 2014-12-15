class AdminContact < ActionMailer::Base
  def contact(message)
    @message = message
    mail(
      to: 'IFADirectoryQueries@moneyadviceservice.org.uk',
      subject: 'IFA Contact'
    )
  end
end
