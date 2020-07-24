module AlgoliaIndex
  class TravelInsuranceFirm < Base
    def update
      serialized = AlgoliaIndex::TravelInsuranceFirmSerializer.new(object)
      AlgoliaIndex.indexed_travel_insurance_firms.add_object(serialized)

      serialized = object.trip_covers.map(&AlgoliaIndex::TravelInsuranceFirmOfferingSerializer.method(:new))
      AlgoliaIndex.indexed_travel_insurance_firm_offerings.add_objects(serialized)
    end
  end
end
