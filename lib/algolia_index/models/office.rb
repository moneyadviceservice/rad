module AlgoliaIndex
  class Office < Base
    class << self
      def create!(offices)
        AlgoliaIndex.index_offices.replace_all_objects(offices)
      end
    end

    def update!
      serialized = AlgoliaIndex::OfficeSerializer.new(object)
      AlgoliaIndex.index_offices.add_object(serialized)
    end

    def destroy!
      AlgoliaIndex.index_offices.delete_object(id)
    end
  end
end
