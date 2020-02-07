class TravelInsuranceRegistrationsController < BaseRegistrationsController
  def registration_title
    'travel_insurance_registrations.heading'
  end
  helper_method :registration_title

  def header_partial
    'shared/travel_header'
  end
  helper_method :header_partial

  def admin_email_address
    "traveldirectory@maps.org.uk"
  end
end
