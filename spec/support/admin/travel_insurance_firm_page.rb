class Admin::TravelInsuranceFirmPage < Admin::FirmPage
  set_url '/admin/travel_insurance_firms/{firm_id}'
  set_url_matcher %r{/admin/travel_insurance_firms/[0-9]+}

  element :registration_questions, '.t-registration-questions'
end
