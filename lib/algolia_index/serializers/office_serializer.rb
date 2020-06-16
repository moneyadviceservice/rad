module AlgoliaIndex
  class OfficeSerializer < ActiveModel::Serializer
    attributes :_geoloc,
               :objectID,
               :firm_id,
               :officeable_type,
               :address_line_one,
               :address_line_two,
               :address_town,
               :address_county,
               :address_postcode,
               :email_address,
               :telephone_number,
               :disabled_access,
               :website

    def objectID # rubocop:disable Naming/MethodName
      object.id
    end

    def firm_id
      object.officeable_id
    end

    def _geoloc
      {
        lat: object.latitude,
        lng: object.longitude
      }
    end
  end
end
