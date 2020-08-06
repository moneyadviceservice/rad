RSpec.describe ServiceDetail, type: :model do
  it { should belong_to :travel_insurance_firm }

  it { should validate_inclusion_of(:offers_telephone_quote).in?([true, false]) }
  it { should validate_inclusion_of(:will_cover_specialist_equipment).in?([true, false]) }
  it { should validate_inclusion_of(:covid19_cancellation_cover).in?([true, false]) }
  it { should validate_inclusion_of(:covid19_medical_repatriation).in?([true, false]) }

  it { should validate_presence_of :medical_screening_company }
  it { should validate_presence_of :how_far_in_advance_trip_cover }

  describe 'before_save' do
    let(:service_detail) { create(:service_detail) }

    it 'clears cover_for_specialist_equipment when will_cover_specialist_equipment is false' do
      service_detail.will_cover_specialist_equipment = false
      service_detail.save

      expect(service_detail.cover_for_specialist_equipment).to be_nil
    end

    it 'does not change any attributes unless will_cover_specialist_equipment is selected' do
      service_detail.offers_telephone_quote = false
      service_detail.save

      expect(service_detail.cover_for_specialist_equipment).not_to be_nil
    end
  end
end
