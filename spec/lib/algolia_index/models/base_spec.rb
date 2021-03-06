RSpec.describe AlgoliaIndex::Base do
  subject(:instance) { described_klass.new(klass: klass, id: id) }

  let(:described_klass) { AlgoliaIndex::Firm }
  let(:klass) { 'Firm' }
  let(:id) { 1 }

  describe '#present_in_db?' do
    context 'when db record exists, it is publishable and it is not hidden' do
      let(:firm) { FactoryBot.create(:firm, id: id) }

      it 'returns true' do
        expect(firm.publishable?).to be_truthy
        expect(firm.hidden_at).to be_nil
        expect(instance).to be_present_in_db
      end
    end

    context 'when db record exists and is hidden' do
      let(:firm) { FactoryBot.create(:firm, id: id, hidden_at: Time.zone.now) }

      it 'returns false' do
        expect(firm.publishable?).to be_truthy
        expect(instance).to_not be_present_in_db
      end
    end

    context 'when db record exists, but it is not publishable' do
      let(:firm) { FactoryBot.create(:firm_without_offices, id: id) }

      it 'returns false' do
        expect(firm.publishable?).to be_falsy
        expect(instance).to_not be_present_in_db
      end
    end

    context 'when db record does not exist' do
      it 'returns false' do
        expect(instance).to_not be_present_in_db
      end
    end
  end

  module DummyModule
    class << self
      def create(*)
        :called_create
      end
    end

    class Firm < AlgoliaIndex::Firm
      def update
        :called_update
      end

      def destroy
        :called_destroy
      end
    end
  end

  describe '.create' do
    let(:described_klass) { DummyModule }

    it 'calls the method on the children' do
      expect(described_klass.create(:dummy)).to eq(:called_create)
    end
  end

  describe '#update' do
    let(:described_klass) { DummyModule::Firm }

    it 'calls the method on the children' do
      expect(instance.update).to eq(:called_update)
    end
  end

  describe '#destroy' do
    let(:described_klass) { DummyModule::Firm }

    it 'calls the method on the children' do
      expect(instance.destroy).to eq(:called_destroy)
    end
  end
end
