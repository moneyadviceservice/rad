module AlgoliaIndex
  class OfficeSerializer < ActiveModel::Serializer
    attributes :_geoloc,
               :objectID,
               :firm_id,
               :address_line_one,
               :address_line_two,
               :address_town,
               :address_county,
               :address_postcode,
               :email_address,
               :telephone_number,
               :disabled_access,
               :website

    delegate :firm_id, to: :object

    def objectID # rubocop:disable Naming/MethodName
      object.id
    end

    def _geoloc
      {
        lat: object.latitude,
        lng: object.longitude
      }
    end
  end
end
