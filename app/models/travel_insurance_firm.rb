class TravelInsuranceFirm < ApplicationRecord
  include FirmApproval

  KNOWN_REGISTRATION_QUESTIONS = %w[
    covered_by_ombudsman_question
    risk_profile_approach_question
    supplies_documentation_when_needed_question
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

  belongs_to :parent, class_name: 'TravelInsuranceFirm'

  has_one :office, -> { order created_at: :asc }, dependent: :destroy, as: :officeable
  has_one :medical_specialism, dependent: :destroy
  has_one :service_detail, dependent: :destroy

  has_one :inactive_firm, as: :firmable, dependent: :destroy

  has_many :subsidiaries, class_name: 'TravelInsuranceFirm',
                          foreign_key: :parent_id,
                          dependent: :destroy

  has_many :trading_names, class_name: 'TravelInsuranceFirm',
                           foreign_key: :parent_id,
                           dependent: :destroy

  has_many :trip_covers, dependent: :destroy
  accepts_nested_attributes_for :trip_covers, :medical_specialism, :service_detail

  scope :approved, -> { where.not(approved_at: nil) }
  scope :hidden, -> { where.not(hidden_at: nil) }
  scope :onboarded, -> { joins(:office) }
  scope :sorted_by_registered_name, -> { order(:registered_name) }

  after_commit :notify_indexer

  def self.ransackable_attributes(*)
    %w[fca_number registered_name]
  end

  def self.ransackable_associations(*)
    %w[principal subsidiaries trading_names]
  end

  def notify_indexer
    UpdateAlgoliaIndexJob.perform_later(model_name.name, id)
  end

  def validate_two_trading_names_only
    return if can_add_more_trading_names?

    errors.add(:base, 'Cannot add more than 2 trading names')
  end

  def can_add_more_trading_names?
    trading_names.count < 2
  end

  def trading_name?
    parent.present?
  end
  alias subsidiary? trading_name?

  def visible_in_directory?
    publishable? && approved? && !hidden?
  end

  def publishable?
    office.present? && cover_and_service_complete?
  end
  alias onboarded? publishable?

  def hidden?
    hidden_at.present?
  end

  def approved?
    approved_at.present?
  end

  def cover_and_service_complete?
    return false unless medical_specialism.present? && service_detail.present?

    trip_covers.any? && trip_covers.map(&:all_complete?).all?
  end

  def main_office
    office
  end

  def self.cache_question_answers(question_answers)
    cache_key = compute_cache_key(fca_number: question_answers[:fca_number], email: question_answers[:email])
    Rails.cache.write(cache_key, question_answers.reject { |key, _value| %w[fca_number email].include? key.to_s }.to_json, expires_in: 1.minute)
  end

  def self.compute_cache_key(fca_number:, email:)
    "#{fca_number}_#{email}"
  end

  private

  def populate_question_answers
    firm_principal = Principal.find_by(fca_number: fca_number)
    cache_key = TravelInsuranceFirm.compute_cache_key(fca_number: fca_number, email: firm_principal.email_address)
    cached_answers = Rails.cache.fetch(cache_key)
    populate_answers(cached_answers) if cached_answers
  end

  def populate_answers(cached_answers)
    cached_answers = JSON.parse(cached_answers)
    cached_answers.keys.each do |question|
      send("#{question}=", cached_answers[question]) if send(question.to_s).nil?
    end
  end
end
