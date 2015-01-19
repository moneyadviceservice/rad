class PreQualificationPage < SitePrism::Page
  set_url '/principals/prequalify'
  set_url_matcher /prequalify/

  element :firm_active_question, '.t-firm-active-question'
  element :firm_business_model_question, '.t-firm-business-model-question'
  element :firm_status_question, '.t-firm-status-question'
  element :firm_particular_market_question, '.t-firm-particular-market-question'
  element :submit, '.button--primary'

  element :error_message, '.global-alert--error'
end
