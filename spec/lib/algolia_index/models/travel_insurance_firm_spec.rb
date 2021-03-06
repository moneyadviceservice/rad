RSpec.describe AlgoliaIndex::TravelInsuranceFirm do
  subject(:instance) { described_class.new(klass: klass, id: id) }

  let(:klass) { 'TravelInsuranceFirm' }
  let(:id) { 1 }

  let(:indexed_travel_insurance_firms) { instance_double(Algolia::Index, add_object: true) }
  let(:indexed_travel_insurance_firm_offerings) { instance_double(Algolia::Index, add_objects: true) }

  before do
    allow(AlgoliaIndex).to receive(:indexed_travel_insurance_firms)
      .and_return(indexed_travel_insurance_firms)

    allow(AlgoliaIndex).to receive(:indexed_travel_insurance_firm_offerings)
      .and_return(indexed_travel_insurance_firm_offerings)
  end

  it { expect(described_class < AlgoliaIndex::Base).to eq(true) }

  describe '#update' do
    context 'when the firm has not been approved' do
      let!(:firm) { FactoryBot.create(:travel_insurance_firm, id: id, completed_firm: true, approved_at: nil) }

      it 'does not update any advisers in the index' do
        expect(indexed_travel_insurance_firms).not_to receive(:add_objects)
        instance.update
      end
    end

    context 'when the firm has been approved' do
      let!(:firm) { FactoryBot.create(:travel_insurance_firm, id: id, completed_firm: true) }
      let(:serialized_travel_firm) { AlgoliaIndex::TravelInsuranceFirmSerializer.new(firm) }

      let(:serialized_offerings) do
        firm.trip_covers.map do |trip_cover|
          AlgoliaIndex::TravelInsuranceFirmOfferingSerializer.new(trip_cover)
        end
      end

      before do
        allow(AlgoliaIndex::TravelInsuranceFirmOfferingSerializer).to receive(:new)
        allow(AlgoliaIndex::TravelInsuranceFirmSerializer).to receive(:new)
      end

      it 'updates all associated offerings in the index' do
        expect(indexed_travel_insurance_firm_offerings).to receive(:add_objects)
          .with(serialized_offerings).exactly(:once)
        instance.update
      end

      it 'update the firm details' do
        expect(indexed_travel_insurance_firms).to receive(:add_object)
          .with(serialized_travel_firm).exactly(:once)
        instance.update
      end
    end
  end

  # describe '#destroy' do
  #   context 'when the office firm is not approved' do
  #     let(:firm) { FactoryBot.create(:travel_insurance_firm, completed_firm: true) }

  #     it 'deletes the office in the index' do
  #       expect(indexed_offices).to receive(:delete_object).with(firm.id)
  #       instance.destroy
  #     end

  #     it 'does not update the firm advisers in the index' do
  #       expect(indexed_advisers).not_to receive(:add_objects)
  #       instance.destroy
  #     end
  #   end

  #   context 'when the office firm is approved' do
  #     include_examples 'update firm advisers', :destroy

  #     let(:firm) { FactoryBot.create(:firm_without_advisers) }

  #     it 'deletes the office in the index' do
  #       expect(indexed_offices).to receive(:delete_object).with(id)
  #       instance.destroy
  #     end
  #   end
  # end
end
