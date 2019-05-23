RSpec.describe AlgoliaIndex::Firm do
  subject(:instance) { described_class.new(klass: klass, id: id) }

  let(:klass) { 'Firm' }
  let(:id) { 1 }

  let(:indexed_advisers) { instance_double(Algolia::Index) }
  let(:indexed_offices) { instance_double(Algolia::Index) }

  before do
    allow(AlgoliaIndex).to receive(:indexed_advisers)
      .and_return(indexed_advisers)

    allow(AlgoliaIndex).to receive(:indexed_offices)
      .and_return(indexed_offices)
  end

  it { expect(described_class < AlgoliaIndex::Base).to eq(true) }

  describe '#update' do
    context 'when the firm does not have any advisers' do
      let!(:firm) { FactoryGirl.create(:firm_without_advisers, id: id) }

      it 'does not update any advisers in the index' do
        expect(indexed_advisers).not_to receive(:add_objects)

        instance.update
      end
    end

    context 'when the firm does have advisers' do
      let!(:firm) { FactoryGirl.create(:firm_with_advisers, id: id) }
      let(:serialized) do
        firm.advisers.geocoded.map do |adviser|
          AlgoliaIndex::AdviserSerializer.new(adviser)
        end
      end

      before do
        allow(AlgoliaIndex::AdviserSerializer).to receive(:new)
          .and_return(*serialized)
      end

      it 'updates all associated advisers in the index' do
        expect(indexed_advisers).to receive(:add_objects)
          .with(serialized).exactly(:once)

        instance.update
      end
    end
  end

  describe '#destroy' do
    it 'doesn\'t delete anything', :aggregate_failures do
      expect(indexed_advisers).not_to receive(:delete_objects)
      expect(indexed_offices).not_to receive(:delete_objects)

      instance.destroy
    end
  end
end
