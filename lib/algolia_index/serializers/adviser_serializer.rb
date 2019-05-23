module AlgoliaIndex
  class AdviserSerializer < ActiveModel::Serializer
    attributes :_geoloc,
               :objectID,
               :name,
               :postcode,
               :travel_distance,
               :qualification_ids,
               :accreditation_ids

    has_one :firm, serializer: AlgoliaIndex::FirmSerializer

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
