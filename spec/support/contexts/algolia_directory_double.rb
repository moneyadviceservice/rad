RSpec.shared_context 'algolia directory double' do
  let(:algolia_advisers_index) { AlgoliaIndexDouble.new('firm-advisers-test') }
  let(:algolia_offices_index) { AlgoliaIndexDouble.new('firm-offices-test') }

  before do
    allow(Algolia::Index).to receive(:new)
      .with('firm-advisers-test')
      .and_return(algolia_advisers_index)
    allow(Algolia::Index).to receive(:new)
      .with('firm-offices-test')
      .and_return(algolia_offices_index)
  end

  after do
    algolia_advisers_index.clear_index
    algolia_offices_index.clear_index
  end

  def advisers_in_directory
    JSON.parse(AlgoliaIndex.indexed_advisers.browse(''))['hits']
  end

  def offices_in_directory
    JSON.parse(AlgoliaIndex.indexed_offices.browse(''))['hits']
  end

  def firm_advisers_in_directory(firm)
    advisers_in_directory.select do |adviser|
      adviser.dig('firm', 'id') == firm.id
    end
  end

  def firm_offices_in_directory(firm)
    offices_in_directory.select do |office|
      office['firm_id'] == firm.id
    end
  end

  def firm_total_offices_in_directory(firm)
    firm_advisers_in_directory(firm).first.dig('firm', 'total_offices')
  end

  def firm_total_advisers_in_directory(firm)
    firm_advisers_in_directory(firm).first.dig('firm', 'total_advisers')
  end

  class AlgoliaIndexDouble
    attr_reader :name

    RESPONSE_ATTRS ||= {
      'processingTimeMS' => 7,
      'query' => '',
      'params' => 'filters=level%3D20',
      'cursor' => 'ARJmaWx0ZXJzPWxldmVsJTNEMjABARoGODA4OTIzvwgAgICAgICAgICAAQ=='
    }.freeze

    def initialize(index_name)
      @name = index_name
      @collection = []
    end

    def delete_object(id)
      collection.delete_if { |elem| elem.objectID == id }
    end

    def add_object(elem)
      stored_at = collection.index { |item| item.objectID == elem.objectID }

      if stored_at
        @collection[stored_at] = elem
      else
        @collection << elem
      end
    end

    def add_objects(elements)
      elements.each { |elem| add_object(elem) }
    end

    def replace_all_objects(elements)
      @collection = [elements]
    end

    def browse(_foo)
      {
        'hits' => collection
      }.merge(RESPONSE_ATTRS).to_json
    end

    def clear_index
      @collection = []
    end

    private

    attr_reader :collection
  end
end
