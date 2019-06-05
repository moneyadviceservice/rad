class Adviser < ActiveRecord::Base
  include Geocodable

  attr_reader :old_firm_id

  belongs_to :firm

  has_and_belongs_to_many :qualifications
  has_and_belongs_to_many :accreditations
  has_and_belongs_to_many :professional_standings

  before_validation :upcase_postcode
  before_validation :upcase_reference_number
  before_validation :assign_name, if: :reference_number?

  validates :travel_distance,
            presence: true,
            inclusion: { in: TravelDistance.all.values }

  validates :postcode,
            presence: true,
            format: { with: /\A[A-Z\d]{1,4} ?[A-Z\d]{1,3}\z/ }

  validates :reference_number,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A[A-Z]{3}[0-9]{5}\z/
            }, unless: :bypass_reference_number_check?

  validate :match_reference_number, unless: :bypass_reference_number_check?

  scope :sorted_by_name, -> { order(:name) }

  after_commit :notify_indexer

  def notify_indexer
    UpdateAlgoliaIndexJob.perform_async(model_name.name, id, firm_id)
  end

  def self.on_firms_with_fca_number(fca_number)
    firms = Firm.where(fca_number: fca_number)
    where(firm: firms)
  end

  def self.move_all_to_firm(receiving_firm)
    transaction do
      current_scope.each do |adviser|
        adviser.update!(firm: receiving_firm)
      end
    end
  end

  def full_street_address
    "#{postcode}, United Kingdom"
  end

  def has_address_changes?
    changed_attributes.include? :postcode
  end

  def add_geocoding_failed_error
    errors.add(
      :geocoding,
      I18n.t("#{model_name.i18n_key}.geocoding.failure_message")
    )
  end

  def field_order
    %i[
      reference_number
      postcode
      travel_distance
    ]
  end

  private

  def upcase_postcode
    postcode.upcase! if postcode.present?
  end

  def upcase_reference_number
    reference_number&.upcase!
  end

  def assign_name
    self.name = name || Lookup::Adviser.find_by(
      reference_number: reference_number
    ).try(:name)
  end

  def match_reference_number
    unless Lookup::Adviser.exists?(reference_number: reference_number)
      errors.add(
        :reference_number,
        I18n.t('adviser.reference_number_unmatched')
      )
    end
  end
end
