class TravelInsuranceRiskProfilePage < SitePrism::Page
  set_url '/travel_insurance_registrations/risk_profile'
  set_url_matcher(/risk_profile/)

  elements :validation_summaries, '.validation-summary__error'

  element :covered_by_ombudsman_question, '.t-covered_by_ombudsman_question'
  element :risk_profile_approach_question, '.t-risk_profile_approach_question'
  element :supplies_documentation_when_needed_question, '.t-supplies_document_when_needed_question'

  element :register, '.button--primary'

  def errored?
    find('.rad-notification--error')
  end
end
