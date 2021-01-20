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
      object.trip_covers.pluck(:id) if object.try(:trip_covers)
    end

    def company
      object.registered_name
    end

    def online
      {
        website: office.try(:website),
        email: office.try(:email_address),
        phone: tel,
        telephone_quote: service_detail.try(:offers_telephone_quote)
      }
    end

    def opening_times
      opening_times = object.main_office.try(:opening_time)
      return {} unless opening_times

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
          most_conditions_covered: medical_specialism.try(:specialised_medical_conditions_covers_all?),
          specialises_in: medical_specialism.try(:specialised_medical_conditions_cover)
        },
        coronavirus_medical_expense: service_detail.try(:covid19_medical_repatriation?),
        coronavirus_cancellation_cover: service_detail.try(:covid19_cancellation_cover?),
        medical_equipment_cover: {
          offers_cover: service_detail.try(:will_cover_specialist_equipment?),
          cover_amount: service_detail.try(:cover_for_specialist_equipment)
        },
        cruise_cover: cruise_cover?,
        medical_screening_company: service_detail.try(:medical_screening_company)
      }
    end

    private

    def medical_specialism
      object.medical_specialism
    end

    def office
      object.main_office
    end

    def service_detail
      object.service_detail
    end

    def tel
      return nil unless office

      office.telephone_number.delete(' ') if office.telephone_number.present?
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
