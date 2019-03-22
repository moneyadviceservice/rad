require_relative 'algolia_index/base'

require_relative 'algolia_index/models/firm'
require_relative 'algolia_index/models/adviser'
require_relative 'algolia_index/models/office'

require_relative 'algolia_index/serializers/firm_serializer'
require_relative 'algolia_index/serializers/adviser_serializer'
require_relative 'algolia_index/serializers/office_serializer'

module AlgoliaIndex
  INDICES = {
    advisers: "firm-advisers#{'-test' if Rails.env.test?}",
    offices: "firm-offices#{'-test' if Rails.env.test?}"
  }.freeze

  class << self
    def handle_update!(klass:, id:)
      record = "AlgoliaIndex::#{klass}".constantize.new(klass: klass, id: id)
      if record.exists?
        record.update!
      else
        record.destroy!
      end
    end

    def index_advisers
      @index_advisers ||= Algolia::Index.new(INDICES[:advisers])
    end

    def index_offices
      @index_offices ||= Algolia::Index.new(INDICES[:offices])
    end
  end
end
