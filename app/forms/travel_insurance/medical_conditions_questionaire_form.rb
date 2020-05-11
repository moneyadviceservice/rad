class TravelInsurance::MedicalConditionsQuestionaireForm
  include ActiveModel::Model

  attr_accessor :metastatic_breast_cancer_question, :ulceritive_colitis_and_anaemia_question,
                :heart_attack_with_hbp_and_high_cholesterol_question, :copd_with_respiratory_infection_question,
                :motor_neurone_disease_question, :hodgkin_lymphoma_question,
                :acute_myeloid_leukaemia_question, :guillain_barre_syndrome_question,
                :heart_failure_and_arrhytmia_question, :stroke_with_hbp_question,
                :peripheral_vascular_disease_question, :schizophrenia_question,
                :lupus_question, :sickle_cell_and_renal_question, :sub_arachnoid_haemorrhage_and_epilepsy_question

  validates :metastatic_breast_cancer_question, :ulceritive_colitis_and_anaemia_question,
            :heart_attack_with_hbp_and_high_cholesterol_question, :copd_with_respiratory_infection_question,
            :motor_neurone_disease_question, :hodgkin_lymphoma_question,
            :acute_myeloid_leukaemia_question, :guillain_barre_syndrome_question,
            :heart_failure_and_arrhytmia_question, :stroke_with_hbp_question,
            :peripheral_vascular_disease_question, :schizophrenia_question,
            :lupus_question, :sickle_cell_and_renal_question, :sub_arachnoid_haemorrhage_and_epilepsy_question,
            inclusion: { in: %w[0 1], message: '%{value} is required' }
end
