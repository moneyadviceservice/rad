class Identification < ActionMailer::Base
  default from: 'RADenquiries@moneyadviceservice.org.uk'

  def contact(principal)
    @principal = principal

    mail(
      to: @principal.email_address,
      subject: 'Your Retirement Adviser Directory Account'
    )
  end
end
