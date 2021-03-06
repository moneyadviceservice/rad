RSpec.describe AlgoliaIndex::TravelInsuranceFirmOfferingSerializer do
  describe 'json' do
    let(:firm) { FactoryBot.create(:travel_insurance_firm, completed_firm: true) }
    let(:trip_cover) { firm.trip_covers.last }
    subject(:serialized) { JSON.parse(described_class.new(trip_cover).to_json) }
    let(:expected_json) do
      {
        objectID: trip_cover.id,
        cover_area: [I18n.t("self_service.travel_insurance_firms_edit.#{trip_cover.cover_area}")],
        trip_type: [I18n.t("self_service.travel_insurance_firms_edit.#{trip_cover.trip_type}.heading")],
        cruise_30_days_max_age: trip_cover.cruise_30_days_max_age,
        cruise_45_days_max_age: trip_cover.cruise_45_days_max_age,
        cruise_50_days_max_age: trip_cover.cruise_50_days_max_age,
        cruise_55_days_max_age: trip_cover.cruise_55_days_max_age,
        land_30_days_max_age: trip_cover.land_30_days_max_age,
        land_45_days_max_age: trip_cover.land_45_days_max_age,
        land_50_days_max_age: trip_cover.land_50_days_max_age,
        land_55_days_max_age: trip_cover.land_55_days_max_age,

        # Service Details
        offers_telephone_quote: ['Yes'],
        will_cover_specialist_equipment: ['Yes'],
        max_cover_for_specialist_equipment: firm.service_detail.cover_for_specialist_equipment,
        covid19_medical_repatriation: ['Yes'],
        covid19_cancellation_cover: ['Yes'],
        medical_screening_company: [I18n.t("self_service.travel_insurance_firms_edit.service_details.medical_screening_companies_select.#{firm.service_detail.medical_screening_company}")],
        how_far_in_advance_trip_cover_weeks: [I18n.t("self_service.travel_insurance_firms_edit.service_details.advance_of_trip_cover_select.#{firm.service_detail.how_far_in_advance_trip_cover}.no_of_weeks")],

        # Medical specialism
        will_cover_all_specialised_medical_conditions: ['No'],
        specialised_medical_conditions_cover: [I18n.t("self_service.travel_insurance_firms_edit.medical_specialism.medical_conditions_cover_select.#{firm.medical_specialism.specialised_medical_conditions_cover}")],
        will_not_cover_some_medical_conditions: ['Yes'],
        likely_not_cover_medical_condition: firm.medical_specialism.likely_not_cover_medical_condition,
        will_cover_terminal_prognosis: ['Yes'],
        will_cover_undergoing_treatment: ['No'],
        not_covering_undergoing_treatment_details: ['Reason why not']
      }.with_indifferent_access
    end

    it { expect(serialized).to eq(expected_json) }
  end
end
