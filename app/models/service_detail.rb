class ServiceDetail < ApplicationRecord
  belongs_to :travel_insurance_firm

  attribute :cover_for_specialist_equipment_select, :boolean

  before_save :clear_cover_for_specialist_equipment_amount, if: :cover_for_specialist_equipment_select

  def completed?
    return false if offers_telephone_quote.nil?

    [
      medical_screening_company,
      how_far_in_advance_trip_cover,
      covid19_medical_repatriation,
      covid19_cancellation_cover
    ].all?
  end

  private

  def clear_cover_for_specialist_equipment_amount
    self.cover_for_specialist_equipment = nil
  end
end
