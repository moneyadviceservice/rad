RSpec.describe AlgoliaIndex::Office do
  subject(:instance) { described_class.new(klass: klass, id: id) }

  let(:klass) { 'Office' }
  let(:id) { rand(100..500) }
  let(:indexed_offices) do
    instance_double(Algolia::Index,
                    add_object: true,
                    add_objects: true,
                    delete_object: true)
  end
  let(:indexed_advisers) { instance_double(Algolia::Index, add_objects: true) }

  before do
    allow(AlgoliaIndex).to receive(:indexed_offices)
      .and_return(indexed_offices)
    allow(AlgoliaIndex).to receive(:indexed_advisers)
      .and_return(indexed_advisers)
  end

  it { expect(described_class < AlgoliaIndex::Base).to eq(true) }

  describe '.create' do
    let!(:offices) { FactoryBot.create_list(:office, 3, firm_id: 1) }
    let(:serialized) do
      offices.map do |office|
        AlgoliaIndex::OfficeSerializer.new(office)
      end
    end

    before do
      allow(AlgoliaIndex::OfficeSerializer).to receive(:new)
        .and_return(*serialized)
    end

    it 'replaces offices in the index' do
      expect(indexed_offices).to receive(:replace_all_objects)
        .with(serialized).exactly(:once)

      described_class.create(offices)
    end
  end

  shared_examples('update firm advisers') do |trigger_call|
    let(:advisers) { FactoryBot.create_list(:adviser, 3, firm: firm) }
    let(:serialized_advisers) do
      advisers.map { |adv| AlgoliaIndex::AdviserSerializer.new(adv) }
    end

    before do
      allow(AlgoliaIndex::AdviserSerializer).to receive(:new)
        .and_return(*serialized_advisers)
    end

    it 'updates all the firm advisers in the index' do
      expect(indexed_advisers).to receive(:add_objects)
        .with(serialized_advisers).exactly(:once)
      instance.send(trigger_call)
    end
  end

  describe '#update' do
    let!(:office) { FactoryBot.create(:office, id: id, firm_id: firm.id) }

    context 'when the office firm is approved' do
      include_examples 'update firm advisers', :update

      let(:firm) { FactoryBot.create(:firm_without_advisers) }
      let(:serialized_office) { AlgoliaIndex::OfficeSerializer.new(office) }

      before do
        allow(AlgoliaIndex::OfficeSerializer).to receive(:new)
          .and_return(*serialized_office)
      end

      it 'updates the office in the index' do
        expect(indexed_offices).to receive(:add_object)
          .with(serialized_office).exactly(:once)
        instance.update
      end
    end

    context 'when the office firm is not approved' do
      let(:firm) { FactoryBot.create(:firm_without_advisers, :not_approved) }

      it 'does not update the office in the index' do
        expect(indexed_offices).not_to receive(:add_object)
        instance.update
      end

      it 'does not update the firm advisers in the index' do
        expect(indexed_advisers).not_to receive(:add_objects)
        instance.update
      end
    end
  end

  describe '#destroy' do
    let!(:office) { FactoryBot.create(:office, id: id, firm_id: firm.id) }

    context 'when the office firm is not approved' do
      let(:firm) { FactoryBot.create(:firm_without_advisers, :not_approved) }

      it 'deletes the office in the index' do
        expect(indexed_offices).to receive(:delete_object).with(id)
        instance.destroy
      end

      it 'does not update the firm advisers in the index' do
        expect(indexed_advisers).not_to receive(:add_objects)
        instance.destroy
      end
    end

    context 'when the office firm is approved' do
      include_examples 'update firm advisers', :destroy

      let(:firm) { FactoryBot.create(:firm_without_advisers) }

      it 'deletes the office in the index' do
        expect(indexed_offices).to receive(:delete_object).with(id)
        instance.destroy
      end
    end
  end
end
