class MedicalSpecialism < ApplicationRecord
  belongs_to :travel_insurance_firm

  attribute :specialised_medical_conditions_cover_select, :boolean
  attribute :likely_not_cover_medical_condition_select, :boolean

  before_save :clear_no_attributes

  private

  def clear_no_attributes
    if specialised_medical_conditions_cover_select == false
      self.specialised_medical_conditions_cover = nil
    end

    if likely_not_cover_medical_condition_select == false
      self.likely_not_cover_medical_condition = nil
    end
  end
end