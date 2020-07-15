class ServiceDetail < ApplicationRecord
  belongs_to :travel_insurance_firm

  attribute :cover_for_specialist_equipment_select, :boolean

  before_save :clear_opening_times

  private

  def clear_opening_times
    if cover_for_specialist_equipment_select == false
      self.cover_for_specialist_equipment = nil
    end
  end
end
