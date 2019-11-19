class PreQualificationPage < SitePrism::Page
  set_url '/retirement_advice_registrations/prequalify'
  set_url_matcher(/retirement_advice_registrations/)

  element :active_question, '.t-active-question'
  element :business_model_question, '.t-business-model-question'
  element :status_question, '.t-status-question'
  element :particular_market_question, '.t-particular-market-question'
  element :consider_available_providers_question, '.t-consider-available-providers-question'
  element :submit, '.t-submit-button'

  element :error_message, '.global-alert--error'
end
