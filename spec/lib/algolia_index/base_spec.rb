RSpec.describe AlgoliaIndex::Base do
  subject(:instance) { described_klass.new(klass: klass, id: id) }

  let(:described_klass) { AlgoliaIndex::Firm }
  let(:klass) { 'Firm' }
  let(:id) { 1 }

  describe 'initialisation' do
    context 'when initialised through an existing children' do
      context 'with valid mapped class' do
        it 'initialises the object' do
          expect(instance).to be_a(described_klass)
        end
      end

      context 'with invalid mapped class' do
        let(:klass) { Class }

        it 'raises an error' do
          expect { instance }.to raise_error(
            described_class::ObjectClassError,
            'expected: Firm, got: Class'
          )
        end
      end
    end

    context 'when initialised directly' do
      let(:described_klass) { described_class }

      it 'raises an error' do
        expect { instance }.to raise_error(
          described_class::ObjectClassError,
          'Base class cannot be initialised directly'
        )
      end
    end
  end

  describe '#exists?' do
    context 'when db record exists' do
      before do
        FactoryGirl.create(:firm, id: id)
      end

      it 'returns true' do
        expect(instance.exists?).to eq(true)
      end
    end

    context 'when db record does not exist' do
      it 'returns false' do
        expect(instance.exists?).to eq(false)
      end
    end
  end

  module DummyModule
    class << self
      def create!(*)
        :called_create
      end
    end

    class Firm < AlgoliaIndex::Firm
      def update!
        :called_update
      end

      def destroy!
        :called_destroy
      end
    end
  end

  describe '.create!' do
    let(:described_klass) { DummyModule }

    it 'calls the method on the children' do
      expect(described_klass.create!(:dummy)).to eq(:called_create)
    end
  end

  describe '#update!' do
    let(:described_klass) { DummyModule::Firm }

    it 'calls the method on the children' do
      expect(instance.update!).to eq(:called_update)
    end
  end

  describe '#destroy!' do
    let(:described_klass) { DummyModule::Firm }

    it 'calls the method on the children' do
      expect(instance.destroy!).to eq(:called_destroy)
    end
  end
end
