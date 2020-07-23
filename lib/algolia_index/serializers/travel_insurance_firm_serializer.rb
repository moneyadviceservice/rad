module AlgoliaIndex
  class TravelInsuranceFirmSerializer < ActiveModel::Serializer
    attributes :objectID,
               :offering_ids,
               :company,
               :online,
               :opening_times

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
        telephone_quote: object.service_detail.offers_telephone_quote
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
  end
end
