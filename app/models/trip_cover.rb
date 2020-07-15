class TripCover < ApplicationRecord
  COVERAGE_AREAS = ['uk_and_europe', 'worldwide_excluding_us_canada', 'worldwide_including_us_canada']
  TRIP_TYPES = ['single_trip', 'annual_multi_trip']

  belongs_to :travel_insurance_firm

  validates_inclusion_of :cover_area, in: COVERAGE_AREAS
  validates_inclusion_of :trip_type, in: TRIP_TYPES

  # validates_presence_of :one_month_land_max_age, :one_month_cruise_max_age,
  #                       :six_month_land_max_age, :six_month_cruise_max_age,
  #                       :six_month_plus_land_max_age, :six_month_plus_cruise_max_age

  COVERAGE_AREAS.each do |area|
    scope area, -> { where(cover_area: area) }
  end

  def all_complete?
    [
      one_month_land_max_age, one_month_cruise_max_age,
      six_month_land_max_age, six_month_cruise_max_age,
      six_month_plus_land_max_age, six_month_plus_cruise_max_age
    ].map(&:present?).all?
  end
end
