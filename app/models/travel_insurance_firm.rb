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

  # TODO: these might get stale if the fca lookup fails so implement a regular clean of the cache or consider using a gem that does so instead of re-inventing the cache implementation wheel
  REGISTRATION_QUESTION_ANSWERS = Hash.new({})

  belongs_to :principal, primary_key: :fca_number, foreign_key: :fca_number

  before_create :populate_question_answers

  def self.cache_question_answers(question_answers)
    cache_key = compute_cache_key(fca_number: question_answers[:fca_number], email: question_answers[:email])
    KNOWN_REGISTRATION_QUESTIONS.each do |question|
      REGISTRATION_QUESTION_ANSWERS[cache_key][question.to_sym] = question_answers[question.to_sym] unless question_answers[question.to_sym].nil?
    end
  end

  def self.compute_cache_key(params)
    "#{params[:fca_number]}_#{params[:email]}".to_sym
  end

  private

  def populate_question_answers
    KNOWN_REGISTRATION_QUESTIONS.each do |question|
      firm_principal = Principal.find_by(fca_number: fca_number)
      cache_key = TravelInsuranceFirm.compute_cache_key(fca_number: fca_number, email: firm_principal.email_address)
      cached_answers = REGISTRATION_QUESTION_ANSWERS[cache_key(fca_number: fca_number, email: principal.email_address)]
      instance_eval("#{question} = '#{cached_answers[question.to_sym]}'", __FILE__, __LINE__) unless cached_answers.empty?

      REGISTRATION_QUESTION_ANSWERS.delete(cache_key)
    end
  end
end
