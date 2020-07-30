RSpec.describe AlgoliaIndex::TravelInsuranceFirmOfferingSerializer do
  describe 'json' do
    let(:trip_cover) { firm.trip_covers.last }
    subject(:serialized) { JSON.parse(described_class.new(trip_cover).to_json) }

    let(:firm) { FactoryBot.create(:travel_insurance_firm, completed_firm: true) }
    let(:expected_json) do
      {
        objectID: trip_cover.id,
        cover_area: trip_cover.cover_area,
        cruise_30_days_max_age: trip_cover.cruise_30_days_max_age,
        cruise_45_days_max_age: trip_cover.cruise_45_days_max_age,
        cruise_55_days_max_age: trip_cover.cruise_55_days_max_age,
        land_30_days_max_age: trip_cover.land_30_days_max_age,
        land_45_days_max_age: trip_cover.land_45_days_max_age,
        land_55_days_max_age: trip_cover.land_55_days_max_age,
        cover_for_specialist_equipment: firm.service_detail.cover_for_specialist_equipment,
        covid19_cancellation_cover: firm.service_detail.covid19_cancellation_cover,
        covid19_medical_repatriation: firm.service_detail.covid19_medical_repatriation,
        how_far_in_advance_trip_cover: firm.service_detail.how_far_in_advance_trip_cover,
        medical_screening_company: firm.service_detail.medical_screening_company,
        offers_telephone_quote: firm.service_detail.offers_telephone_quote,
        cover_undergoing_treatment: firm.medical_specialism.cover_undergoing_treatment,
        likely_not_cover_medical_condition: firm.medical_specialism.likely_not_cover_medical_condition,
        specialised_medical_conditions_covers_all: false,
        specialised_medical_conditions_cover: firm.medical_specialism.specialised_medical_conditions_cover,
        terminal_prognosis_cover: firm.medical_specialism.terminal_prognosis_cover,
        trip_type: trip_cover.trip_type
      }.with_indifferent_access
    end

    it { expect(serialized).to eq(expected_json) }
  end
end
