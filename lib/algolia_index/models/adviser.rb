module AlgoliaIndex
  class Adviser < Base
    class << self
      def create(advisers)
        serialized = advisers.map(&AlgoliaIndex::AdviserSerializer.method(:new))
        AlgoliaIndex.indexed_advisers.replace_all_objects(serialized)
      end
    end

    def update
      firm.update_advisers
    end

    def destroy
      AlgoliaIndex.indexed_advisers.delete_object(id)
      firm.update_advisers
    end
  end
end
