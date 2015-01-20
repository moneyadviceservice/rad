RSpec.describe OngoingAdviceFeeStructure do
  subject(:ongoing_advice_fee_structure) { build(:ongoing_advice_fee_structure) }

  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(ongoing_advice_fee_structure).to be_valid
    end

    describe 'name' do
      context 'when not present' do
        before { ongoing_advice_fee_structure.name = nil }

        it { is_expected.to_not be_valid }
      end
    end
  end
end
