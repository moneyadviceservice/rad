RSpec.describe AlgoliaIndex::Firm do
  subject(:instance) { described_class.new(klass: klass, id: id) }

  let(:klass) { 'Firm' }
  let(:id) { 1 }

  let(:indexed_advisers) { instance_double(Algolia::Index, add_objects: true) }
  let(:indexed_offices) { instance_double(Algolia::Index, add_objects: true) }

  before do
    allow(AlgoliaIndex).to receive(:indexed_advisers)
      .and_return(indexed_advisers)

    allow(AlgoliaIndex).to receive(:indexed_offices)
      .and_return(indexed_offices)
  end

  it { expect(described_class < AlgoliaIndex::Base).to eq(true) }

  describe '#update' do
    context 'when the firm has not been approved' do
      let!(:firm) do
        FactoryGirl.create(:firm_with_advisers_and_offices,
                           :not_approved, 
                           id: id)
      end

      it 'does not update any advisers in the index' do
        expect(indexed_advisers).not_to receive(:add_objects)
        instance.update
      end

      it 'does not update any offices in the index' do
        expect(indexed_offices).not_to receive(:add_objects)
        instance.update
      end
    end

    context 'when the approved firm has advisers but no offices' do
      let!(:firm) do
        FactoryGirl.create(:firm_with_advisers,
                           :without_offices,
                           id: id)
      end

      let(:serialized_advisers) do
        firm.advisers.geocoded.map do |adviser|
          AlgoliaIndex::AdviserSerializer.new(adviser)
        end
      end

      before do
        allow(AlgoliaIndex::AdviserSerializer).to receive(:new)
          .and_return(*serialized_advisers)
      end

      it 'updates all associated advisers in the index' do
        expect(indexed_advisers).to receive(:add_objects)
          .with(serialized_advisers).exactly(:once)
        instance.update
      end

      it 'does not update any offices in the index' do
        expect(indexed_offices).not_to receive(:add_objects)
        instance.update
      end
    end

    context 'when the approved firm has offices but no advisers' do
      let!(:firm) do
        FactoryGirl.create(:firm_with_offices,
                           :without_advisers,
                           id: id)
      end

      let(:serialized_offices) do
        firm.offices.geocoded.map do |office|
          AlgoliaIndex::OfficeSerializer.new(office)
        end
      end

      before do
        allow(AlgoliaIndex::OfficeSerializer).to receive(:new)
          .and_return(*serialized_offices)
      end

      it 'updates all associated offices in the index' do
        expect(indexed_offices).to receive(:add_objects)
          .with(serialized_offices).exactly(:once)
        instance.update
      end

      it 'does not update any advisers in the index' do
        expect(indexed_advisers).not_to receive(:add_objects)
        instance.update
      end
    end

    context 'when the approved firm has advisers and offices' do
      let!(:firm) do
        FactoryGirl.create(:firm_with_advisers_and_offices, id: id)
      end

      let(:serialized_advisers) do
        firm.advisers.geocoded.map do |adviser|
          AlgoliaIndex::AdviserSerializer.new(adviser)
        end
      end

      let(:serialized_offices) do
        firm.offices.geocoded.map do |office|
          AlgoliaIndex::OfficeSerializer.new(office)
        end
      end

      before do
        allow(AlgoliaIndex::AdviserSerializer).to receive(:new)
          .and_return(*serialized_advisers)
        allow(AlgoliaIndex::OfficeSerializer).to receive(:new)
          .and_return(*serialized_offices)
      end

      it 'updates all associated advisers in the index' do
        expect(indexed_advisers).to receive(:add_objects)
          .with(serialized_advisers).exactly(:once)
        instance.update
      end

      it 'updates all associated offices in the index' do
        expect(indexed_offices).to receive(:add_objects)
          .with(serialized_offices).exactly(:once)
        instance.update
      end
    end
  end

  describe '#update_advisers' do
    context 'when the firm does not have any advisers' do
      let!(:firm) { FactoryGirl.create(:firm_without_advisers, id: id) }

      it 'does not update any advisers in the index' do
        expect(indexed_advisers).not_to receive(:add_objects)
        instance.update
      end
    end

    context 'when the firm does have advisers' do
      context 'when the firm has been approved' do
        let!(:firm) do
          FactoryGirl.create(:firm_with_advisers, id: id)
        end

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
          instance.update_advisers
        end
      end

      context 'when the firm has not been approved' do
        let!(:firm) do
          FactoryGirl.create(:firm_with_advisers, :not_approved, id: id)
        end

        it 'does not update any advisers in the index' do
          expect(indexed_advisers).not_to receive(:add_objects)
          instance.update_advisers
        end
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
