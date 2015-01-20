RSpec.describe InitialAdviceFeeStructure do
  subject(:initial_advice_fee_structure) { build(:initial_advice_fee_structure) }

  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(initial_advice_fee_structure).to be_valid
    end

    describe 'name' do
      context 'when not present' do
        before { initial_advice_fee_structure.name = nil }

        it { is_expected.to_not be_valid }
      end
    end
  end
end
