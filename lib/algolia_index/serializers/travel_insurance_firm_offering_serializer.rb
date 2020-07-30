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

    [
      :offers_telephone_quote,
      :cover_for_specialist_equipment,
      :medical_screening_company,
      :how_far_in_advance_trip_cover,
      :covid19_medical_repatriation,
      :covid19_cancellation_cover
    ].each do |attr|
      define_method(attr) do
        service_detail.send(attr)
      end
    end

    [
      :specialised_medical_conditions_covers_all,
      :specialised_medical_conditions_cover,
      :likely_not_cover_medical_condition,
      :cover_undergoing_treatment,
      :terminal_prognosis_cover
    ].each do |attr|
      define_method(attr) do
        medical_specialism.send(attr)
      end
    end

    private

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
