class PreQualificationPage < SitePrism::Page
  set_url '/principals/prequalify'
  set_url_matcher(/prequalify/)

  element :active_question, '.t-active-question'
  element :business_model_question, '.t-business-model-question'
  element :status_question, '.t-status-question'
  element :particular_market_question, '.t-particular-market-question'
  element :consider_available_providers_question, '.t-consider-available-providers-question'
  element :submit, '.button--primary'

  element :error_message, '.global-alert--error'
end
