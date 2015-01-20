RSpec.describe AllowedPaymentMethod do
  subject(:allowed_payment_method) { build(:allowed_payment_method) }

  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(allowed_payment_method).to be_valid
    end

    describe 'name' do
      context 'when not present' do
        before { allowed_payment_method.name = nil }

        it { is_expected.to_not be_valid }
      end
    end
  end
end
