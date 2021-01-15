RSpec.shared_context 'algolia index fake' do
  let(:algolia_advisers_index) { AlgoliaIndex::Fake.new('firm-advisers-test') }
  let(:algolia_offices_index) { AlgoliaIndex::Fake.new('firm-offices-test') }

  let(:algolia_travel_firms_index) { AlgoliaIndex::Fake.new('travel-firms-test') }
  let(:algolia_travel_firms_offerings_index) { AlgoliaIndex::Fake.new('travel-firm-offerings-test') }

  before do
    allow(Algolia::Index).to receive(:new)
      .with('firm-advisers-test')
      .and_return(algolia_advisers_index)

    allow(Algolia::Index).to receive(:new)
      .with('firm-offices-test')
      .and_return(algolia_offices_index)

    allow(Algolia::Index).to receive(:new)
      .with('travel-firms-test')
      .and_return(algolia_travel_firms_index)

    allow(Algolia::Index).to receive(:new)
      .with('travel-firm-offerings-test')
      .and_return(algolia_travel_firms_offerings_index)
  end

  after do
    algolia_advisers_index.clear_index
    algolia_offices_index.clear_index
    Rails.logger.info("CLEARING UP SHITSTORM")
    algolia_travel_firms_index.clear_index
    algolia_travel_firms_offerings_index.clear_index
  end

  def travel_firms_in_directory
    JSON.parse(AlgoliaIndex.indexed_travel_insurance_firms.browse(''))['hits']
  end

  def travel_firm_offerings_in_directory
    JSON.parse(AlgoliaIndex.indexed_travel_insurance_firm_offerings.browse(''))['hits']
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
end
