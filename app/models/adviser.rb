class Adviser < ActiveRecord::Base
  belongs_to :firm

  has_and_belongs_to_many :qualifications
  has_and_belongs_to_many :accreditations
  has_and_belongs_to_many :professional_standings
  has_and_belongs_to_many :professional_bodies

  before_validation :assign_name, if: :reference_number?

  before_validation :clear_geographical_coverage, if: :covers_whole_of_uk?

  validates_acceptance_of :confirmed_disclaimer, accept: true

  validates :covers_whole_of_uk,
    inclusion: { in: [true, false] }

  validates :travel_distance,
    presence: true,
    inclusion: { in: TravelDistance.all },
    unless: :covers_whole_of_uk?

  validates :postcode,
    presence: true,
    format: { with: /\A[A-Z\d]{1,4} [A-Z\d]{1,3}\z/ },
    unless: :covers_whole_of_uk?

  validates :reference_number,
    presence: true,
    uniqueness: true,
    format: {
      with: /\A[A-Z]{3}[0-9]{5}\z/
    }

  validate :match_reference_number

  def field_order
    [
      :reference_number,
      :covers_whole_of_uk,
      :postcode,
      :travel_distance,
      :confirmed_disclaimer
    ]
  end

  private

  def clear_geographical_coverage
    self.postcode = ''
    self.travel_distance = 0
  end

  def assign_name
    self.name = Lookup::Adviser.find_by(
      reference_number: reference_number
    ).try(:name)
  end

  def match_reference_number
    unless Lookup::Adviser.exists?(reference_number: reference_number)
      errors.add(
        :reference_number,
        I18n.t('questionnaire.adviser.reference_number_un_matched')
      )
    end
  end
end
