class Admin::FirmMailer < ApplicationMailer
  def rejected_firm(principal_details)
    @principal_details = principal_details

    mail(
      to: ENV['TAD_ADMIN_EMAIL'],
      subject: 'Travel insurance directory rejected firm'
    )
  end
end
