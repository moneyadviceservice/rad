RSpec.describe TripCover, type: :model do
  describe 'associations' do
    it { should belong_to :travel_insurance_firm }
  end

  describe 'validations' do
    it { should validate_inclusion_of(:trip_type).in_array(TripCover::TRIP_TYPES) }
    it { should validate_inclusion_of(:cover_area).in_array(TripCover::COVERAGE_AREAS) }

    # it { should validates_presence_of :one_month_land_max_age }
    # it { should validates_presence_of :one_month_cruise_max_age }
    # it { should validates_presence_of :six_month_land_max_age }
    # it { should validates_presence_of :six_month_cruise_max_age }
    # it { should validates_presence_of :six_month_plus_land_max_age }
    # it { should validates_presence_of :six_month_plus_cruise_max_age }
  end
end
