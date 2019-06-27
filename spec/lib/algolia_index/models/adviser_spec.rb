RSpec.describe AlgoliaIndex::Adviser do
  subject(:instance) { described_class.new(klass: klass, id: id) }

  let(:klass) { 'Adviser' }
  let(:id) { 1 }

  let(:indexed_advisers) do
    instance_double(Algolia::Index,
                    add_object: true,
                    add_objects: true,
                    delete_object: true)
  end

  before do
    allow(AlgoliaIndex).to receive(:indexed_advisers)
      .and_return(indexed_advisers)
  end

  it { expect(described_class < AlgoliaIndex::Base).to eq(true) }

  describe '.create' do
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
      expect(indexed_advisers).to receive(:replace_all_objects)
        .with(serialized).exactly(:once)

      described_class.create(advisers)
    end
  end

  shared_examples('update firm advisers') do |trigger_call|
    let!(:adviser) { FactoryGirl.create(:adviser, id: id) }
    let(:dependant_advisers) do
      FactoryGirl.create_list(:adviser, 3, firm: adviser.firm)
    end

    let(:serialized_advisers) do
      ([adviser] + dependant_advisers).map do |adv|
        AlgoliaIndex::AdviserSerializer.new(adv)
      end
    end

    before do
      allow(AlgoliaIndex::AdviserSerializer).to receive(:new)
        .and_return(*serialized_advisers)
    end

    context 'when the adviser firm is approved' do
      it 'updates all the firm advisers in the index' do
        expect(indexed_advisers).to receive(:add_objects)
          .with(serialized_advisers).exactly(:once)
        instance.send(trigger_call)
      end
    end

    context 'when the adviser firm is not approved' do
      before { adviser.firm.update_column(:approved_at, nil) }

      it 'does not update the firm advisers in the index' do
        expect(indexed_advisers).not_to receive(:add_objects)
        instance.send(trigger_call)
      end
    end
  end

  describe '#update' do
    include_examples 'update firm advisers', :update
  end

  describe '#destroy' do
    include_examples 'update firm advisers', :destroy

    it 'deletes the adviser in the index' do
      expect(indexed_advisers).to receive(:delete_object).with(id)
      instance.destroy
    end
  end
end
