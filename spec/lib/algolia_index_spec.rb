RSpec.describe AlgoliaIndex do
  describe '.handle_update!' do
    subject(:handle_update!) do
      described_class.handle_update!(klass: klass, id: id, firm_id: firm_id)
    end

    let(:klass) { 'Firm' }
    let(:id) { 1 }
    let(:firm_id) { nil }
    let(:algolia_index) do
      instance_double(AlgoliaIndex::Firm, exists?: exists?)
    end

    context 'when record exists in the db' do
      let(:exists?) { true }

      it 'updates the record in the index', :aggregate_failures do
        expect(AlgoliaIndex::Firm).to receive(:new)
          .with(klass: klass, id: id, firm_id: firm_id)
          .and_return(algolia_index)

        expect(algolia_index).to receive(:update!)

        handle_update!
      end
    end

    context 'when record does not exist in the db' do
      let(:exists?) { false }

      it 'destroys the record from the index', :aggregate_failures do
        expect(AlgoliaIndex::Firm).to receive(:new)
          .with(klass: klass, id: id, firm_id: firm_id)
          .and_return(algolia_index)

        expect(algolia_index).to receive(:destroy!)

        handle_update!
      end
    end
  end

  describe '.index_advisers' do
    it 'returns the advisers index from Algolia' do
      expect(described_class.index_advisers.name).to eq('firm-advisers-test')
    end
  end

  describe '.index_offices' do
    it 'returns the offices index from Algolia' do
      expect(described_class.index_offices.name).to eq('firm-offices-test')
    end
  end
end
