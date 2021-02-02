RSpec.describe AlgoliaIndex do
  describe '.handle_update' do
    subject(:handle_update) do
      described_class.handle_update(klass: klass, id: id, firm_id: firm_id)
    end

    let(:klass) { 'Firm' }
    let(:id) { 1 }
    let(:firm_id) { nil }
    let(:algolia_index) do
      instance_double(AlgoliaIndex::Firm, present_in_db?: present_in_db?)
    end

    context 'when record exists in the db, and is publishable and not hidden' do
      let(:present_in_db?) { true }

      it 'updates the record in the index', :aggregate_failures do
        expect(AlgoliaIndex::Firm).to receive(:new)
          .with(klass: klass, id: id, firm_id: firm_id)
          .and_return(algolia_index)

        expect(algolia_index).to receive(:update)

        handle_update
      end
    end

    context 'when record does not exist in the db, or it is not publishable or hidden' do
      let(:present_in_db?) { false }

      it 'destroys the record from the index', :aggregate_failures do
        expect(AlgoliaIndex::Firm).to receive(:new)
          .with(klass: klass, id: id, firm_id: firm_id)
          .and_return(algolia_index)

        expect(algolia_index).to receive(:destroy)

        handle_update
      end
    end
  end

  describe '.indexed_advisers' do
    it 'returns the advisers index from Algolia' do
      expect(described_class.indexed_advisers.name).to eq('firm-advisers-test')
    end
  end

  describe '.indexed_offices' do
    it 'returns the offices index from Algolia' do
      expect(described_class.indexed_offices.name).to eq('firm-offices-test')
    end
  end

  describe '.indexed_travel_insurance_firms' do
    it 'returns the travel firms index from Algolia' do
      expect(described_class.indexed_travel_insurance_firms.name).to eq('travel-firms-test')
    end
  end

  describe '.indexed_travel_insurance_firm_offerings' do
    it 'returns the travel firm offerings index from Algolia' do
      expect(described_class.indexed_travel_insurance_firm_offerings.name).to eq('travel-firm-offerings-test')
    end
  end
end
