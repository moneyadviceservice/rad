module AlgoliaIndex
  class TravelInsuranceFirmSerializer < ActiveModel::Serializer
    include ActionView::Helpers::NumberHelper

    attributes :objectID,
               :offering_ids,
               :company,
               :online,
               :opening_times,
               :overview

    def objectID # rubocop:disable Naming/MethodName
      object.id
    end

    def offering_ids
      object.trip_covers.pluck(:id)
    end

    def company
      object.registered_name
    end

    def online
      {
        website: object.main_office.website,
        email: object.main_office.email_address,
        phone: object.main_office.telephone_number,
        telephone_quote: service_detail.offers_telephone_quote
      }
    end

    def opening_times
      opening_times = object.main_office.opening_time

      {
        week_days: {
          open_time: opening_times.weekday_opening_time.to_s(:time),
          close_time: opening_times.weekday_closing_time.to_s(:time)
        },
        saturdays: {
          open_time: opening_times.saturday_opening_time&.to_s(:time),
          close_time: opening_times.saturday_closing_time&.to_s(:time)
        },
        sundays: {
          open_time: opening_times.sunday_opening_time&.to_s(:time),
          close_time: opening_times.sunday_closing_time&.to_s(:time)
        }
      }
    end

    def overview
      [
        {
          heading: 'Medical conditions covered',
          text: medical_conditions_text
        },
        {
          heading: 'Offers Coronavirus cover for medical expenses',
          text: service_detail.covid19_medical_repatriation? ? 'Yes' : 'No'
        },
        {
          heading: 'Offers Coronavirus cover if trip cancelled',
          text: service_detail.covid19_cancellation_cover? ? 'Yes' : 'No'
        },
        {
          heading: 'Medical equipment cover',
          text: specialist_equipment_text
        },
        {
          heading: 'Cruise cover',
          text: cruise_cover? ? 'Yes' : 'No'
        },
        {
          heading: 'Medical Screening company used',
          text: I18n.t("self_service.travel_insurance_firms_edit.service_details.medical_screening_companies_select.#{service_detail.medical_screening_company}")
        }
      ]
    end

    private

    def medical_conditions_text
      return 'most conditions covered' if medical_specialism.specialised_medical_conditions_covers_all?

      "specialises in #{I18n.t("self_service.travel_insurance_firms_edit.medical_specialism.medical_conditions_cover_select.#{medical_specialism.specialised_medical_conditions_cover}")}"
    end

    def specialist_equipment_text
      if service_detail.will_cover_specialist_equipment? && service_detail.cover_for_specialist_equipment > 0
        "yes up to £#{number_with_delimiter(service_detail.cover_for_specialist_equipment)}"
      else
        'cover for medical equipment not offered'
      end
    end

    def medical_specialism
      object.medical_specialism
    end

    def service_detail
      object.service_detail
    end

    def cruise_cover?
      object.trip_covers.where(
        "trip_covers.cruise_30_days_max_age > 0 OR
         trip_covers.cruise_45_days_max_age > 0 OR
         trip_covers.cruise_55_days_max_age > 0"
      ).any?
    end
  end
end
