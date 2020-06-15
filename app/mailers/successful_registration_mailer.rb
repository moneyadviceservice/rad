class SuccessfulRegistrationMailer < ActionMailer::Base
  def contact(principal, registration_type)
    @principal = principal

    mail(
      to: @principal.email_address,
      subject: 'Your Directory Account',
      template_name: registration_type
    )
  end
end
