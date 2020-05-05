class TravelInsuranceFirm < ApplicationRecord
  include FirmApproval

  KNOWN_REGISTRATION_QUESTIONS = %w[
    covered_by_ombudsman_question
    risk_profile_approach_question
    covers_medical_condition_question
    metastatic_breast_cancer_question
    ulceritive_colitis_and_anaemia_question
    heart_attack_with_hbp_and_high_cholesterol_question
    copd_with_respiratory_infection_question
    motor_neurone_disease_question
    hodgkin_lymphoma_question
    acute_myeloid_leukaemia_question
    guillain_barre_syndrome_question
    heart_failure_and_arrhytmia_question
    stroke_with_hbp_question
    peripheral_vascular_disease_question
    schizophrenia_question
    lupus_question
    sickle_cell_and_renal_question
    sub_arachnoid_haemorrhage_and_epilepsy_question
  ].freeze

  REGISTRATION_QUESTION_ANSWERS = Hash.new({})

  belongs_to :principal, primary_key: :fca_number, foreign_key: :fca_number

  before_create :populate_question_answers

  def cache_question_answers(fca_number, question_answers)
    KNOWN_REGISTRATION_QUESTIONS.each do |question|
      REGISTRATION_QUESTION_ANSWERS[fca_number.to_s.to_sym][question.to_sym] = question_answers[question.to_sym]
    end
  end

  private

  def populate_question_answers
    KNOWN_REGISTRATION_QUESTIONS.each do |question|
      send("#{question}=", REGISTRATION_QUESTION_ANSWERS[fca_number][:question.to_sym]) unless REGISTRATION_QUESTION_ANSWERS[fca_number].empty?
    end
  end
end
