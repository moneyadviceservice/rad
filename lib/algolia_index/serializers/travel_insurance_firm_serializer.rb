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
        phone: object.main_office.telephone_number.delete(' '),
        telephone_quote: service_detail.offers_telephone_quote
      }
    end

    def opening_times
      opening_times = object.main_office.opening_time

      {
        week_days: {
          opens: opening_times.weekday_opening_time.present?,
          open_time: opening_times.weekday_opening_time.to_s(:time),
          close_time: opening_times.weekday_closing_time.to_s(:time)
        },
        saturdays: {
          opens: opening_times.saturday_opening_time.present?,
          open_time: opening_times.saturday_opening_time&.to_s(:time),
          close_time: opening_times.saturday_closing_time&.to_s(:time)
        },
        sundays: {
          opens: opening_times.sunday_opening_time.present?,
          open_time: opening_times.sunday_opening_time&.to_s(:time),
          close_time: opening_times.sunday_closing_time&.to_s(:time)
        }
      }
    end

    def overview
      {
        medical_conditions_cover: {
          most_conditions_covered: medical_specialism.specialised_medical_conditions_covers_all?,
          specialises_in: medical_specialism.specialised_medical_conditions_cover
        },
        coronavirus_medical_expense: service_detail.covid19_medical_repatriation?,
        coronavirus_cancellation_cover: service_detail.covid19_cancellation_cover?,
        medical_equipment_cover: {
          offers_cover: service_detail.will_cover_specialist_equipment?,
          cover_amount: service_detail.cover_for_specialist_equipment
        },
        cruise_cover: cruise_cover?,
        medical_screening_company: service_detail.medical_screening_company
      }
    end

    private

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
