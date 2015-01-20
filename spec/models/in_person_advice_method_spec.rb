RSpec.describe InPersonAdviceMethod do
  subject(:in_person_advice_method) { build(:in_person_advice_method) }

  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(in_person_advice_method).to be_valid
    end

    describe 'name' do
      context 'when not present' do
        before { in_person_advice_method.name = nil }

        it { is_expected.to_not be_valid }
      end
    end
  end
end
