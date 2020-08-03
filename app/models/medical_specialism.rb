class MedicalSpecialism < ApplicationRecord
  belongs_to :travel_insurance_firm

  attribute :likely_not_cover_medical_condition_select, :boolean

  before_save :clear_no_attributes

  validates :likely_not_cover_medical_condition, presence: true, if: :likely_not_cover_medical_condition_select
  validates :specialised_medical_conditions_cover, presence: true, unless: :specialised_medical_conditions_covers_all

  def completed?
    [
      cover_undergoing_treatment,
      terminal_prognosis_cover
    ].all?
  end

  private

  def clear_no_attributes
    self.specialised_medical_conditions_cover = nil if specialised_medical_conditions_covers_all == true
    self.likely_not_cover_medical_condition = nil if likely_not_cover_medical_condition_select == false
  end
end
