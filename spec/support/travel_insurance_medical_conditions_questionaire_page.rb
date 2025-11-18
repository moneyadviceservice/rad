class TravelInsuranceMedicalConditionsQuestionairePage < SitePrism::Page
  set_url '/travel_insurance_registrations/medical_conditions_questionaire'
  set_url_matcher(/medical_conditions_questionaire/)

  elements :validation_summaries, '.validation-summary__error'

  element :metastatic_breast_cancer_question, '.t-metastatic_breast_cancer_question'
  element :ulceritive_colitis_and_anaemia_question, '.t-ulceritive_colitis_and_anaemia_question'
  element :heart_attack_with_hbp_and_high_cholesterol_question, '.t-heart_attack_with_hbp_and_high_cholesterol_question'
  element :copd_with_respiratory_infection_question, '.t-copd_with_respiratory_infection_question'
  element :motor_neurone_disease_question, '.t-motor_neurone_disease_question'
  element :hodgkin_lymphoma_question, '.t-hodgkin_lymphoma_question'
  element :acute_myeloid_leukaemia_question, '.t-acute_myeloid_leukaemia_question'
  element :guillain_barre_syndrome_question, '.t-guillain_barre_syndrome_question'
  element :heart_failure_and_arrhytmia_question, '.t-heart_failure_and_arrhytmia_question'
  element :stroke_with_hbp_question, '.t-stroke_with_hbp_question'
  element :peripheral_vascular_disease_question, '.t-peripheral_vascular_disease_question'
  element :schizophrenia_question, '.t-schizophrenia_question'
  element :lupus_question, '.t-lupus_question'
  element :sickle_cell_and_renal_question, '.t-sickle_cell_and_renal_question'
  element :sub_arachnoid_haemorrhage_and_epilepsy_question, '.t-sub_arachnoid_haemorrhage_and_epilepsy_question'
  element :prostate_cancer_question, '.t-prostate_cancer_question'
  element :type_one_diabetes_question, '.t-type_one_diabetes_question'
  element :parkinsons_disease_question, '.t-parkinsons_disease_question'
  element :hiv_question, '.t-hiv_question'

  element :register, '.button--primary'

  def errored?
    find('.rad-notification--error')
  end
end
