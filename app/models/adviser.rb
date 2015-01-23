class Adviser < ActiveRecord::Base
  belongs_to :firm

  has_and_belongs_to_many :qualifications
  has_and_belongs_to_many :accreditations
  has_and_belongs_to_many :professional_standings
  has_and_belongs_to_many :professional_bodies

  validates_acceptance_of :confirmed_disclaimer, accept: true

  validates :reference_number,
    presence: true,
    format: {
      with: /\A[A-Z]{3}[0-9]{5}\z/
    }

  validate :match_reference_number

  def field_order
    %i(reference_number confirmed_disclaimer)
  end

  private

  def match_reference_number
    unless Lookup::Adviser.exists?(reference_number: reference_number)
      errors.add(
        :reference_number,
        I18n.t('questionnaire.adviser.reference_number_un_matched')
      )
    end
  end
end
