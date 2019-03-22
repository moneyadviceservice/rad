RSpec.describe AlgoliaIndex::Office do
  subject(:instance) { described_class.new(klass: klass, id: id) }

  let(:klass) { 'Office' }
  let(:id) { 1 }

  let(:index_offices) { instance_double(Algolia::Index) }

  before do
    allow(AlgoliaIndex).to receive(:index_offices)
      .and_return(index_offices)
  end

  it { expect(described_class < AlgoliaIndex::Base).to eq(true) }

  describe '#update!' do
    let!(:office) { FactoryGirl.create(:office, id: id, firm_id: 1) }
    let(:serialized) { AlgoliaIndex::OfficeSerializer.new(office) }

    before do
      allow(AlgoliaIndex::OfficeSerializer).to receive(:new)
        .and_return(*serialized)
    end

    it 'updates the office in the index' do
      expect(index_offices).to receive(:add_object)
        .with(serialized).exactly(:once)

      instance.update!
    end
  end

  describe '#destroy!' do
    it 'deletes the office in the index' do
      expect(index_offices).to receive(:delete_object).with(id)

      instance.destroy!
    end
  end
end
