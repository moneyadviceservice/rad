module AlgoliaIndex
  class Firm < Base
    def update
      advisers = object&.advisers&.geocoded
      return if advisers.blank?

      serialized = advisers.map(&AlgoliaIndex::AdviserSerializer.method(:new))
      AlgoliaIndex.indexed_advisers.add_objects(serialized)
    end

    def destroy
      # Do nothing, because we don't maintain a Firm index.
    end
  end
end
