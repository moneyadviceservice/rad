RSpec.describe InvestmentSize do
  subject(:investment_size) { build(:investment_size) }

  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(investment_size).to be_valid
    end

    describe 'name' do
      context 'when not present' do
        before { investment_size.name = nil }

        it { is_expected.to_not be_valid }
      end
    end
  end
end
