module AlgoliaIndex
  class AdviserSerializer < ActiveModel::Serializer
    attributes :_geoloc,
               :name,
               :postcode,
               :travel_distance,
               :qualification_ids,
               :accreditation_ids

    has_one :firm

    def _geoloc
      {
        lat: object.latitude,
        lng: object.longitude
      }
    end
  end
end
