module AlgoliaIndex
  class TravelInsuranceFirm < Base
    def update
      serialized = AlgoliaIndex::TravelInsuranceFirmSerializer.new(object)
      AlgoliaIndex.indexed_travel_insurance_firms.add_object(serialized)

      serialized = object.trip_covers.map(&AlgoliaIndex::TravelInsuranceFirmOfferingSerializer.method(:new))
      AlgoliaIndex.indexed_travel_insurance_firm_offerings.add_objects(serialized)
    end

    def destroy
      AlgoliaIndex.indexed_travel_insurance_firms.delete_object(id)
    end
  end
end
