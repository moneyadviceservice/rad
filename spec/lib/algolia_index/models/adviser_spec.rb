RSpec.describe AlgoliaIndex::Adviser do
  subject(:instance) { described_class.new(klass: klass, id: id) }

  let(:klass) { 'Adviser' }
  let(:id) { 1 }

  let(:index_advisers) { instance_double(Algolia::Index) }

  before do
    allow(AlgoliaIndex).to receive(:index_advisers)
      .and_return(index_advisers)
  end

  it { expect(described_class < AlgoliaIndex::Base).to eq(true) }

  describe '.create!' do
    let!(:advisers) { FactoryGirl.create_list(:adviser, 3) }
    let(:serialized) do
      advisers.map do |adviser|
        AlgoliaIndex::AdviserSerializer.new(adviser)
      end
    end

    before do
      allow(AlgoliaIndex::AdviserSerializer).to receive(:new)
        .and_return(*serialized)
    end

    it 'replaces advisers in the index' do
      expect(index_advisers).to receive(:replace_all_objects)
        .with(serialized).exactly(:once)

      described_class.create!(advisers)
    end
  end

  describe '#update!' do
    let!(:adviser) { FactoryGirl.create(:adviser, id: id) }
    let(:serialized) { AlgoliaIndex::AdviserSerializer.new(adviser) }

    before do
      allow(AlgoliaIndex::AdviserSerializer).to receive(:new)
        .and_return(*serialized)
    end

    it 'updates the adviser in the index' do
      expect(index_advisers).to receive(:add_object)
        .with(serialized).exactly(:once)

      instance.update!
    end
  end

  describe '#destroy!' do
    it 'deletes the adviser in the index' do
      expect(index_advisers).to receive(:delete_object).with(id)

      instance.destroy!
    end
  end
end