module SelfService
  class TravelInsuranceFirmsController < AbstractTravelInsuranceFirmsController
    def index
      firm = principal.travel_insurance_firm
      trading_names = firm.trading_names

      @presenter = FirmsIndexPresenter.new(
        firm,
        trading_names,
        available_trading_names(firm: firm)
      )
    end

    def edit
      @firm = principal.travel_insurance_firm
      build_coverage_fields
      @firm.build_medical_specialism if @firm.medical_specialism.blank?
      @firm.build_service_detail if @firm.service_detail.blank?
    end

    def update
      @firm = principal.travel_insurance_firm

      if @firm.update(firm_params)
        flash[:notice] = I18n.t('self_service.firm_edit.saved')
        redirect_to_edit
      else
        render :edit
      end
    end

    private

    def available_trading_names(firm:)
      registered_trading_names = firm.trading_names
      Lookup::Subsidiary
        .where(fca_number: firm.fca_number)
        .order(:name)
        .reject do |lookup_name|
          registered_trading_names.map(&:registered_name)
                                  .include? lookup_name.name
        end
    end

    def build_coverage_fields
      @single_trip_europe = @firm.trip_covers.find_or_initialize_by(cover_area: 'uk_and_europe', trip_type: 'single_trip')
      @multi_trip_europe = @firm.trip_covers.find_or_initialize_by(cover_area: 'uk_and_europe', trip_type: 'annual_multi_trip')

      @single_worldwide_us = @firm.trip_covers.find_or_initialize_by(cover_area: 'worldwide_including_us_canada', trip_type: 'single_trip')
      @multi_worldwide_us = @firm.trip_covers.find_or_initialize_by(cover_area: 'worldwide_including_us_canada', trip_type: 'annual_multi_trip')

      @single_worldwide_ex_us = @firm.trip_covers.find_or_initialize_by(cover_area: 'worldwide_excluding_us_canada', trip_type: 'single_trip')
      @multi_worldwide_ex_us = @firm.trip_covers.find_or_initialize_by(cover_area: 'worldwide_excluding_us_canada', trip_type: 'annual_multi_trip')
    end

    def firm_params
      params.require(:travel_insurance_firm).permit(
        trip_covers_attributes: [
          :id,
          :trip_type,
          :cover_area,
          :one_month_land_max_age,
          :one_month_cruise_max_age,
          :six_month_land_max_age,
          :six_month_cruise_max_age,
          :six_month_plus_land_max_age,
          :six_month_plus_cruise_max_age
        ],
        medical_specialism_attributes: [
          :id,
          :specialised_medical_conditions_cover_select,
          :likely_not_cover_medical_condition_select,
          :specialised_medical_conditions_cover,
          :likely_not_cover_medical_condition,
          :cover_undergoing_treatment,
          :terminal_prognosis_cover
        ],
        service_detail_attributes: [
          :id,
          :offers_telephone_quote,
          :cover_for_specialist_equipment_select,
          :cover_for_specialist_equipment,
          :medical_screening_company,
          :how_far_in_advance_trip_cover
        ]
      )
    end
  end
end
