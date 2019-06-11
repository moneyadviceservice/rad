module AlgoliaIndex
  class Office < Base
    class << self
      def create(offices)
        serialized = offices.map(&AlgoliaIndex::OfficeSerializer.method(:new))
        AlgoliaIndex.indexed_offices.replace_all_objects(serialized)
      end
    end

    def update
      return unless firm.approved?

      serialized = AlgoliaIndex::OfficeSerializer.new(object)
      AlgoliaIndex.indexed_offices.add_object(serialized)
      firm.update_advisers
    end

    def destroy
      AlgoliaIndex.indexed_offices.delete_object(id)
      firm.update_advisers
    end
  end
end
