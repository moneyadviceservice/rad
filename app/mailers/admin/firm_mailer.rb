class Admin::FirmMailer < ApplicationMailer
  def rejected_firm(principal_details)
    @principal_details = principal_details

    mail(
      to: ENV['TAD_ADMIN_EMAIL'],
      subject: 'Travel insurance directory rejected firm'
    )
  end

  def reregistered_firm(travel_insurance_firm)
    @travel_insurance_firm = travel_insurance_firm

    mail(
      to: ENV['TAD_ADMIN_EMAIL'],
      subject: 'Travel insurance directory reregistered firm'
    )
  end
end
