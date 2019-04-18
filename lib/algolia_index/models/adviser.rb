module AlgoliaIndex
  class Adviser < Base
    class << self
      def create!(advisers)
        serialized = advisers.map(&AlgoliaIndex::AdviserSerializer.method(:new))
        AlgoliaIndex.index_advisers.replace_all_objects(serialized)
      end
    end

    def update!
      advisers = object.firm.advisers.geocoded # update all dependant advisers
      serialized = advisers.map(&AlgoliaIndex::AdviserSerializer.method(:new))
      AlgoliaIndex.index_advisers.add_objects(serialized)
    end

    def destroy!
      AlgoliaIndex.index_advisers.delete_object(id)
    end
  end
end
