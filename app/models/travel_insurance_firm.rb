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
  ].map(&:to_sym).freeze

  belongs_to :principal, primary_key: :fca_number, foreign_key: :fca_number

  before_create :populate_question_answers

  def self.cache_question_answers(question_answers)
    the_questions = KNOWN_REGISTRATION_QUESTIONS.filter { |question| question_answers.key?(question) }
    the_questions.each do |question|
      cache_key = compute_cache_key(fca_number: question_answers[:fca_number], email: question_answers[:email], question: question)
      # TODO: consider placing timeouts in config
      Rails.cache.write(cache_key, question_answers[question.to_sym], expires_in: 1.minute)
    end
  end

  def self.compute_cache_key(params)
    "#{params[:fca_number]}_#{params[:email]}_#{params[:question]}"
  end

  private

  def populate_question_answers
    firm_principal = Principal.find_by(fca_number: fca_number)

    KNOWN_REGISTRATION_QUESTIONS.each do |question|
      cache_key = TravelInsuranceFirm.compute_cache_key(fca_number: fca_number, email: firm_principal.email_address, question: question)
      cached_answer = Rails.cache.fetch(cache_key) { nil }
      send("#{question}=", cached_answer) if send(question.to_s).nil?
    end
  end
end
