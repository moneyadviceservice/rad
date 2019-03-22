module AlgoliaIndex
  class Firm < Base
    def update!
      advisers = object&.advisers&.geocoded
      return if advisers.blank?

      serialized = advisers.map(&AlgoliaIndex::AdviserSerializer.method(:new))
      AlgoliaIndex.index_advisers.add_objects(serialized)
    end

    def destroy!
      # Nothing to be directly destroyed in any index
    end
  end
end
