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

               # Service details
               :offers_telephone_quote,
               :will_cover_specialist_equipment,
               :max_cover_for_specialist_equipment,
               :covid19_medical_repatriation,
               :covid19_cancellation_cover,
               :medical_screening_company,
               :how_far_in_advance_trip_cover,

               # Medical specialism
               :will_cover_all_specialised_medical_conditions,
               :specialised_medical_conditions_cover,
               :will_not_cover_some_medical_conditions,
               :likely_not_cover_medical_condition,
               :will_cover_terminal_prognosis,
               :will_cover_undergoing_treatment,
               :not_covering_undergoing_treatment_details

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
    def offers_telephone_quote
      [bool_to_string(service_detail.offers_telephone_quote)]
    end

    def will_cover_specialist_equipment
      [bool_to_string(service_detail.will_cover_specialist_equipment)]
    end

    def max_cover_for_specialist_equipment
      service_detail.cover_for_specialist_equipment
    end

    [:covid19_medical_repatriation, :covid19_cancellation_cover].each do |attr|
      define_method(attr) do
        [bool_to_string(service_detail.send(attr))]
      end
    end

    def medical_screening_company
      [I18n.t("self_service.travel_insurance_firms_edit.service_details.medical_screening_companies_select.#{service_detail.medical_screening_company}")]
    end

    def how_far_in_advance_trip_cover
      [I18n.t("self_service.travel_insurance_firms_edit.service_details.advance_of_trip_cover_select.#{service_detail.how_far_in_advance_trip_cover}")]
    end

    [
      :covid19_medical_repatriation,
      :covid19_cancellation_cover
    ].each do |attr|
      define_method(attr) do
        [bool_to_string(service_detail.send(attr))]
      end
    end

    # Medical specialism
    def will_cover_all_specialised_medical_conditions
      [bool_to_string(medical_specialism.specialised_medical_conditions_covers_all)]
    end

    def specialised_medical_conditions_cover
      return if medical_specialism.specialised_medical_conditions_covers_all

      [I18n.t("self_service.travel_insurance_firms_edit.medical_specialism.medical_conditions_cover_select.#{medical_specialism.specialised_medical_conditions_cover}")]
    end

    def will_not_cover_some_medical_conditions
      [bool_to_string(medical_specialism.will_not_cover_some_medical_conditions)]
    end

    def likely_not_cover_medical_condition
      medical_specialism.likely_not_cover_medical_condition
    end

    def will_cover_terminal_prognosis
      [bool_to_string(medical_specialism.terminal_prognosis_cover)]
    end

    def will_cover_undergoing_treatment
      [bool_to_string(medical_specialism.will_cover_undergoing_treatment)]
    end

    def not_covering_undergoing_treatment_details
      [medical_specialism.cover_undergoing_treatment]
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
