class AdminContact < ActionMailer::Base
  def contact(email, message)
    @email = email
    @message = message
    mail subject: 'IFA Contact'
  end
end
