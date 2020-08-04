module AlgoliaIndex
  class TravelInsuranceFirm < Base
    class << self
      def create(travel_firms)
        serialized_firms = travel_firms.map(&AlgoliaIndex::TravelInsuranceFirmSerializer.method(:new))
        AlgoliaIndex.indexed_travel_insurance_firms.replace_all_objects(serialized_firms)

        serialized_offerings = []
        travel_firms.find_each do |firm|
          serialized_offerings.concat(firm.trip_covers.map(&AlgoliaIndex::TravelInsuranceFirmOfferingSerializer.method(:new)))
        end

        AlgoliaIndex.indexed_travel_insurance_firm_offerings.replace_all_objects(serialized_offerings)
      end
    end

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