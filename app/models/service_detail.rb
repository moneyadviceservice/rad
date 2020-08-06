class ServiceDetail < ApplicationRecord
  belongs_to :travel_insurance_firm

  validates :offers_telephone_quote,
            :will_cover_specialist_equipment,
            :covid19_cancellation_cover,
            :covid19_medical_repatriation,
            inclusion: { in: [true, false] }

  validates :medical_screening_company, :how_far_in_advance_trip_cover, presence: true
  validates :cover_for_specialist_equipment, presence: true, if: :will_cover_specialist_equipment

  before_save :clear_cover_for_specialist_equipment_amount, unless: :will_cover_specialist_equipment

  private

  def clear_cover_for_specialist_equipment_amount
    return if will_cover_specialist_equipment.nil?

    self.cover_for_specialist_equipment = nil
  end
end
