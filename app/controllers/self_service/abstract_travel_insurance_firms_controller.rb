module SelfService
  class AbstractTravelInsuranceFirmsController < ApplicationController
    before_action :authenticate_user!

    FIRM_PARAMS = [
      :website_address,
      :covered_by_ombudsman_question,
      :risk_profile_approach_question,
      trip_covers_attributes: [
        :id,
        :trip_type,
        :cover_area,
        :land_30_days_max_age,
        :cruise_30_days_max_age,
        :land_45_days_max_age,
        :cruise_45_days_max_age,
        :land_50_days_max_age,
        :cruise_50_days_max_age,
        :land_55_days_max_age,
        :cruise_55_days_max_age
      ],
      medical_specialism_attributes: [
        :id,
        :specialised_medical_conditions_covers_all,
        :will_not_cover_some_medical_conditions,
        :specialised_medical_conditions_cover,
        :likely_not_cover_medical_condition,
        :will_cover_undergoing_treatment,
        :cover_undergoing_treatment,
        :terminal_prognosis_cover
      ],
      service_detail_attributes: [
        :id,
        :offers_telephone_quote,
        :covid19_medical_repatriation,
        :covid19_cancellation_cover,
        :will_cover_specialist_equipment,
        :cover_for_specialist_equipment,
        :medical_screening_company,
        :how_far_in_advance_trip_cover
      ]
    ].freeze

    protected

    def principal
      current_user.principal
    end

    def firm_params
      params.require(:travel_insurance_firm).permit(*FIRM_PARAMS)
    end

    def build_travel_firm_associations
      @firm.build_medical_specialism unless @firm.medical_specialism
      @firm.build_service_detail unless @firm.service_detail

      @single_trip_europe = find_or_initialize_covers(cover_area: 'uk_and_europe', trip_type: 'single_trip')
      @multi_trip_europe = find_or_initialize_covers(cover_area: 'uk_and_europe', trip_type: 'annual_multi_trip')

      @single_worldwide_us = find_or_initialize_covers(cover_area: 'worldwide_including_us_canada', trip_type: 'single_trip')
      @multi_worldwide_us = find_or_initialize_covers(cover_area: 'worldwide_including_us_canada', trip_type: 'annual_multi_trip')

      @single_worldwide_ex_us = find_or_initialize_covers(cover_area: 'worldwide_excluding_us_canada', trip_type: 'single_trip')
      @multi_worldwide_ex_us = find_or_initialize_covers(cover_area: 'worldwide_excluding_us_canada', trip_type: 'annual_multi_trip')
    end

    def find_or_initialize_covers(cover_area:, trip_type:)
      @firm.trip_covers.select { |tc| tc.cover_area == cover_area && tc.trip_type == trip_type }&.first ||
        @firm.trip_covers.find_or_initialize_by(cover_area: cover_area, trip_type: trip_type)
    end

    def redirect_to_edit(firm_id: params[:firm_id])
      redirect_to(
        controller: params[:controller],
        action: :edit,
        firm_id: firm_id
      )
    end
  end
end
