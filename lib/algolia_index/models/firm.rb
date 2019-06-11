module AlgoliaIndex
  class Firm < Base
    def update
      return unless approved?
      update_offices
      update_advisers
    end

    def update_advisers
      advisers = object&.advisers&.geocoded
      return unless approved? && advisers.present?

      serialized = advisers.map(&AlgoliaIndex::AdviserSerializer.method(:new))
      AlgoliaIndex.indexed_advisers.add_objects(serialized)
    end

    def update_offices
      offices = object&.offices&.geocoded
      return unless approved? && offices.present?

      serialized = offices.map(&AlgoliaIndex::OfficeSerializer.method(:new))
      AlgoliaIndex.indexed_offices.add_objects(serialized)
    end

    def destroy
      # Do nothing, because we don't maintain a Firm index.
    end

    def approved?
      object&.approved_at.present?
    end
  end
end
