module AlgoliaIndex
  class Adviser < Base
    class << self
      def create!(advisers)
        serialized = advisers.map(&AlgoliaIndex::AdviserSerializer.method(:new))
        AlgoliaIndex.index_advisers.replace_all_objects(serialized)
      end
    end

    delegate :update!, to: :firm

    def destroy!
      AlgoliaIndex.index_advisers.delete_object(id)
      firm.update!
    end
  end
end
