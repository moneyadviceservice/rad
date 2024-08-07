class Firm < ApplicationRecord # rubocop:disable Metrics/ClassLength
  include FirmApproval
  FREE_INITIAL_MEETING_VALID_VALUES = [true, false].freeze

  # We use a scalar required field as a marker to detect a firm that has been
  # onboarded. That is, it has been saved with validations on update having
  # been run.
  ONBOARDED_MARKER_FIELD = :free_initial_meeting
  ONBOARDED_MARKER_FIELD_VALID_VALUES = FREE_INITIAL_MEETING_VALID_VALUES

  ADVICE_TYPES_ATTRIBUTES = %i[
    retirement_income_products_flag
    pension_transfer_flag
    long_term_care_flag
    equity_release_flag
    inheritance_tax_and_estate_planning_flag
    wills_and_probate_flag
  ].freeze

  scope :approved, -> { where.not(approved_at: nil) }
  scope :onboarded, -> { where.not(ONBOARDED_MARKER_FIELD => nil) }
  scope :sorted_by_registered_name, -> { order(:registered_name) }

  def self.languages_used
    pluck(Arel.sql('DISTINCT unnest("languages")')).sort
  end

  has_and_belongs_to_many :in_person_advice_methods
  has_and_belongs_to_many :other_advice_methods
  has_and_belongs_to_many :initial_advice_fee_structures
  has_and_belongs_to_many :ongoing_advice_fee_structures
  has_and_belongs_to_many :allowed_payment_methods
  has_and_belongs_to_many :investment_sizes

  belongs_to :initial_meeting_duration
  belongs_to :principal, primary_key: :fca_number, foreign_key: :fca_number
  belongs_to :parent, class_name: 'Firm'

  has_one :inactive_firm, as: :firmable, dependent: :destroy
  has_many :advisers, dependent: :destroy
  has_many :offices, -> { order created_at: :asc }, dependent: :destroy, as: :officeable
  has_many :subsidiaries, class_name: 'Firm',
                          foreign_key: :parent_id,
                          dependent: :destroy
  has_many :trading_names, class_name: 'Firm',
                           foreign_key: :parent_id,
                           dependent: :destroy
  has_many :qualifications, -> { reorder('').distinct }, through: :advisers
  has_many :accreditations, -> { reorder('').distinct }, through: :advisers

  attr_accessor :percent_total
  attr_accessor :primary_advice_method

  before_validation :clear_inapplicable_advice_methods,
                    if: -> { primary_advice_method == :remote }
  before_validation :clear_blank_languages
  before_validation :deduplicate_languages

  # A set of attributes that are validated on first update. A firm is
  # considered onboarded once these details have been provided.
  with_options on: :update do |firm|
    firm.validates :website_address,
      allow_blank: true,
      length: { maximum: 300 },
      format: { with: /\A(https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z0-9-]+/ }

    firm.validates :free_initial_meeting,
      inclusion: { in: FREE_INITIAL_MEETING_VALID_VALUES }

    firm.validates :initial_meeting_duration,
      presence: true,
      if: -> { free_initial_meeting? }

    firm.validates :initial_advice_fee_structures,
      length: { minimum: 1 }

    firm.validates :ongoing_advice_fee_structures,
      length: { minimum: 1 }

    firm.validates :allowed_payment_methods,
      length: { minimum: 1 }

    firm.validates :minimum_fixed_fee,
      allow_blank: false,
      numericality: {
        only_integer: true,
        greater_than_or_equal_to: 0,
        less_than: 2_147_483_648 # max value for postgres integer type
      }

    firm.validates :in_person_advice_methods,
      presence: true,
      if: -> { primary_advice_method == :local }

    firm.validates :other_advice_methods,
      presence: true,
      if: -> { primary_advice_method == :remote }

    ADVICE_TYPES_ATTRIBUTES.each do |attribute|
      firm.validates attribute, inclusion: { in: [true, false] }
    end

    firm.validates :primary_advice_method, presence: true

    firm.validate :languages do
      errors.add(:languages, :invalid) unless languages.all? do |lang|
        Languages::AVAILABLE_LANGUAGES_ISO_639_3_CODES.include?(lang)
      end
    end

    firm.validate do
      errors.add(:advice_types, :invalid) unless advice_types.values.any?
    end

    firm.validates :investment_sizes, length: { minimum: 1 }
  end

  after_commit :notify_indexer

  def self.ransackable_attributes(*)
    %w[
      equity_release_flag
      ethical_investing_flag
      fca_number
      id
      inheritance_tax_and_estate_planning_flag
      languages
      long_term_care_flag
      pension_transfer_flag
      registered_name
      retirement_income_products_flag
      sharia_investing_flag
      wills_and_probate_flag
      workplace_financial_advice_flag
      created_at
      approved_at
    ]
  end

  def self.ransackable_associations(*)
    %w[
      accreditations
      advisers
      allowed_payment_methods
      in_person_advice_methods
      inactive_firm
      initial_advice_fee_structures
      initial_meeting_duration
      investment_sizes
      offices
      ongoing_advice_fee_structures
      other_advice_methods
      parent
      principal
      qualifications
      subsidiaries
      trading_names
    ]
  end

  def notify_indexer
    UpdateAlgoliaIndexJob.perform_later(model_name.name, id)
  end

  if Rails.env.test?
    # A helper to shield tests from modifying the marker field directly
    def __set_registered(state)
      new_value = state ? ONBOARDED_MARKER_FIELD_VALID_VALUES.first : nil
      send("#{ONBOARDED_MARKER_FIELD}=", new_value)
    end
    alias __registered= __set_registered
  end

  enum status: { independent: 1, restricted: 2 }

  def in_person_advice?
    in_person_advice_methods.present?
  end
  alias postcode_searchable? in_person_advice?

  def trading_name?
    parent.present?
  end

  alias subsidiary? trading_name?

  def field_order
    [
      :website_address,
      :address_line_one,
      :address_line_two,
      :address_town,
      :address_county,
      :address_postcode,
      :primary_advice_method,
      :in_person_advice_methods,
      :other_advice_methods,
      :free_initial_meeting,
      :initial_meeting_duration,
      :initial_advice_fee_structures,
      :ongoing_advice_fee_structures,
      :allowed_payment_methods,
      :minimum_fixed_fee,
      :percent_total,
      *ADVICE_TYPES_ATTRIBUTES,
      :ethical_investing_flag,
      :sharia_investing_flag,
      :languages,
      :investment_sizes
    ]
  end

  def advice_types
    ADVICE_TYPES_ATTRIBUTES.map { |a| [a, self[a]] }.to_h
  end

  def primary_advice_method
    return @primary_advice_method.to_sym if @primary_advice_method
    infer_primary_advice_method
  end

  def main_office
    offices.first
  end

  def onboarded?
    !send(ONBOARDED_MARKER_FIELD).nil?
  end

  def visible_in_directory?
    publishable? && approved? && !hidden?
  end

  def publishable?
    onboarded? && offices.any? && advisers.any?
  end

  def hidden?
    hidden_at.present?
  end

  def approved?
    approved_at.present?
  end

  private

  def infer_primary_advice_method
    if in_person_advice_methods.any?
      :local
    elsif other_advice_methods.any?
      :remote
    end
  end

  def clear_inapplicable_advice_methods
    self.in_person_advice_methods = []
  end

  def clear_blank_languages
    languages.reject! &:blank?
  end

  def deduplicate_languages
    languages.uniq!
  end
end
