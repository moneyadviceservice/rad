class TripCover < ApplicationRecord
  COVERAGE_AREAS = %w[uk_and_europe worldwide_excluding_us_canada worldwide_including_us_canada].freeze
  TRIP_TYPES = %w[single_trip annual_multi_trip].freeze

  belongs_to :travel_insurance_firm

  validates :cover_area, inclusion: COVERAGE_AREAS
  validates :trip_type, inclusion: TRIP_TYPES

  COVERAGE_AREAS.each do |area|
    scope area, -> { where(cover_area: area) }
  end

  def all_complete?
    [
      land_30_days_max_age, cruise_30_days_max_age,
      land_45_days_max_age, cruise_45_days_max_age,
      land_55_days_max_age, cruise_55_days_max_age
    ].map(&:present?).all?
  end
end
