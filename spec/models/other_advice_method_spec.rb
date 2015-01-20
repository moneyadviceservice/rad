RSpec.describe OtherAdviceMethod do
  subject(:other_advice_method) { build(:other_advice_method) }

  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(other_advice_method).to be_valid
    end

    describe 'name' do
      context 'when not present' do
        before { other_advice_method.name = nil }

        it { is_expected.to_not be_valid }
      end
    end
  end
end
