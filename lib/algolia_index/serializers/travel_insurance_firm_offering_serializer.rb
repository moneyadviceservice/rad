module AlgoliaIndex
  class TravelInsuranceFirmOfferingSerializer < ActiveModel::Serializer
    attributes :objectID,
               :trip_type,
               :cover_area,
               :land_30_days_max_age,
               :cruise_30_days_max_age,
               :land_45_days_max_age,
               :cruise_45_days_max_age,
               :land_55_days_max_age,
               :cruise_55_days_max_age,
               :offers_telephone_quote,
               :cover_for_specialist_equipment,
               :medical_screening_company,
               :how_far_in_advance_trip_cover,
               :covid19_medical_repatriation,
               :covid19_cancellation_cover,
               :specialised_medical_conditions_covers_all,
               :specialised_medical_conditions_cover,
               :likely_not_cover_medical_condition,
               :cover_undergoing_treatment,
               :terminal_prognosis_cover

    def objectID # rubocop:disable Naming/MethodName
      object.id
    end

    # Trip covers
    def cover_area
      [I18n.t("self_service.travel_insurance_firms_edit.#{object.cover_area}")]
    end

    def trip_type
      [I18n.t("self_service.travel_insurance_firms_edit.#{object.trip_type}.heading")]
    end

    # Service details
    def how_far_in_advance_trip_cover
      [I18n.t("self_service.travel_insurance_firms_edit.service_details.advance_of_trip_cover_select.#{service_detail.how_far_in_advance_trip_cover}")]
    end

    def medical_screening_company
      [I18n.t("self_service.travel_insurance_firms_edit.service_details.medical_screening_companies_select.#{service_detail.medical_screening_company}")]
    end

    def cover_for_specialist_equipment
      service_detail.cover_for_specialist_equipment
    end

    [
      :offers_telephone_quote,
      :covid19_medical_repatriation,
      :covid19_cancellation_cover
    ].each do |attr|
      define_method(attr) do
        [bool_to_string(service_detail.send(attr))]
      end
    end

    # Medical specialism
    def specialised_medical_conditions_cover
      return if medical_specialism.specialised_medical_conditions_covers_all

      [I18n.t("self_service.travel_insurance_firms_edit.medical_specialism.medical_conditions_cover_select.#{medical_specialism.specialised_medical_conditions_cover}")]
    end

    def likely_not_cover_medical_condition
      medical_specialism.likely_not_cover_medical_condition
    end

    [
      :cover_undergoing_treatment,
      :terminal_prognosis_cover,
      :specialised_medical_conditions_covers_all
    ].each do |attr|
      define_method(attr) do
        [bool_to_string(medical_specialism.send(attr))]
      end
    end

    private

    def bool_to_string(data)
      return if data.nil?

      data ? 'Yes' : 'No'
    end

    def travel_firm
      object.travel_insurance_firm
    end

    def service_detail
      travel_firm.service_detail
    end

    def medical_specialism
      travel_firm.medical_specialism
    end
  end
end
