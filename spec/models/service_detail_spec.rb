RSpec.describe ServiceDetail, type: :model do
  it { should belong_to :travel_insurance_firm }

  describe 'before_save' do
    let(:service_detail) { create(:service_detail) }

    it 'clears cover_for_specialist_equipment when cover_for_specialist_equipment_select is false' do
      service_detail.cover_for_specialist_equipment_select = false
      service_detail.save

      expect(service_detail.cover_for_specialist_equipment).to be_nil
    end

    it 'does not change any attributes unless cover_for_specialist_equipment_select is selected' do
      service_detail.offers_telephone_quote = false
      service_detail.save

      expect(service_detail.cover_for_specialist_equipment).not_to be_nil
    end
  end

  describe '#completed?' do
    context 'when offers_telephone_quote is set to nil' do
      let(:service_detail) { create(:service_detail, offers_telephone_quote: nil) }
      it { expect(service_detail.completed?).to eq false }
    end

    context 'when all required fields are present' do
      let(:service_detail) { create(:service_detail) }
      it { expect(service_detail.completed?).to eq true }
    end

    context 'when not all required fields are present' do
      let(:service_detail) { create(:service_detail, how_far_in_advance_trip_cover: nil) }
      it { expect(service_detail.completed?).to eq false }
    end
  end
end
