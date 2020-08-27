require_relative 'algolia_index/models/base'
require_relative 'algolia_index/models/firm'
require_relative 'algolia_index/models/adviser'
require_relative 'algolia_index/models/office'
require_relative 'algolia_index/models/travel_insurance_firm'

require_relative 'algolia_index/serializers/firm_serializer'
require_relative 'algolia_index/serializers/adviser_serializer'
require_relative 'algolia_index/serializers/office_serializer'

require_relative 'algolia_index/serializers/travel_insurance_firm_serializer'
require_relative 'algolia_index/serializers/travel_insurance_firm_offering_serializer'

module AlgoliaIndex
  INDICES = {
    advisers: "firm-advisers#{'-test' if Rails.env.test?}",
    offices: "firm-offices#{'-test' if Rails.env.test?}",
    travel_firms: "travel-firms#{'-test' if Rails.env.test?}",
    travel_firms_combined: "travel-firms-combined#{'-test' if Rails.env.test?}",
    travel_firm_offerings: "travel-firm-offerings#{'-test' if Rails.env.test?}"
  }.freeze

  class << self
    def handle_update(klass:, id:, firm_id:)
      indexed_record = "AlgoliaIndex::#{klass}".constantize.new(
        klass: klass,
        id: id,
        firm_id: firm_id
      )
      if indexed_record.present_in_db?
        indexed_record.update
      else
        indexed_record.destroy
      end
    end

    def indexed_travel_insurance_firms
      @indexed_travel_insurance_firms ||= Algolia::Index.new(INDICES[:travel_firms])
    end

    def indexed_travel_insurance_firms_combined
      @indexed_travel_insurance_firms ||= Algolia::Index.new(INDICES[:travel_firms_combined])
    end

    def indexed_travel_insurance_firm_offerings
      @indexed_travel_insurance_firm_offerings ||= Algolia::Index.new(INDICES[:travel_firm_offerings])
    end

    def indexed_advisers
      @indexed_advisers ||= Algolia::Index.new(INDICES[:advisers])
    end

    def indexed_offices
      @indexed_offices ||= Algolia::Index.new(INDICES[:offices])
    end
  end
end
