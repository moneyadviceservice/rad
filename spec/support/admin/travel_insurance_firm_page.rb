class Admin::TravelInsuranceFirmPage < Admin::FirmPage
  set_url '/admin/travel_insurance_firms/{firm_id}'
  set_url_matcher %r{/admin/travel_insurance_firms/[0-9]+}

  element :registration_questions, '.t-registration-questions'
  element :hide_button, 'input[value="Hide firm from directory"]'
  element :unhide_button, 'input[value="Add Hidden firm to directory"]'
  element :hidden, 'p:contains("Hidden:")'

  element :reregister_approve, '.t-reregister-approve'
  element :reregister_approved_label, '.t-reregister-approved-label'
end
