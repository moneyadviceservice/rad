class TravelInsuranceMedicalConditionsPage < SitePrism::Page
  set_url '/travel_insurance_registrations/medical_conditions'
  set_url_matcher(/medical_conditions/)

  elements :validation_summaries, '.validation-summary__error'

  element :covers_medical_condition_question, '.t-covers_medical_condition_question'

  element :register, '.button--primary'

  def errored?
    find('.rad-notification--error')
  end
end
