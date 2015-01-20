RSpec.describe ServiceRegion do
  subject(:service_region) { build(:service_region) }

  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(service_region).to be_valid
    end

    describe 'name' do
      context 'when not present' do
        before { service_region.name = nil }

        it { is_expected.to_not be_valid }
      end
    end
  end
end
