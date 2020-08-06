class MedicalSpecialism < ApplicationRecord
  belongs_to :travel_insurance_firm

  before_save :clear_no_attributes

  validates :terminal_prognosis_cover,
            :will_not_cover_some_medical_conditions,
            :will_cover_undergoing_treatment,
            inclusion: { in: [true, false] }

  validates :specialised_medical_conditions_cover, presence: true, unless: :specialised_medical_conditions_covers_all
  validates :likely_not_cover_medical_condition, presence: true, if: :will_not_cover_some_medical_conditions
  validates :cover_undergoing_treatment, presence: true, unless: :will_cover_undergoing_treatment

  private

  def clear_no_attributes
    self.specialised_medical_conditions_cover = nil if specialised_medical_conditions_covers_all == true
    self.likely_not_cover_medical_condition = nil if will_not_cover_some_medical_conditions == false
    self.cover_undergoing_treatment = nil if will_cover_undergoing_treatment == true
  end
end
