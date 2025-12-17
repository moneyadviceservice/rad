RSpec.describe User do
  describe 'validation' do
    it 'passes with valid email address' do
      subject.email = 'bill@example.com'
      subject.valid?
      expect(subject.errors_on(:email)).to be_empty
    end

    it 'fails with an invalid email address' do
      subject.email = 'bill'
      subject.valid?
      expect(subject.errors_on(:email)).not_to be_empty
    end
  end

  describe '#active_for_authentication?' do
    context 'when the principal is nonexistent' do
      it 'is false' do
        subject.principal = nil

        expect(subject).not_to be_active_for_authentication
      end
    end

    context 'when the principal has no travel insurance firm' do
      it 'is false' do
        subject.principal = build(:principal, travel_insurance_firm: nil)

        expect(subject).not_to be_active_for_authentication
      end
    end

    context 'when the principal has a travel insurance firm' do
      it 'is true' do
        subject.principal = build(:travel_insurance_firm_with_principal).principal

        expect(subject).not_to be_active_for_authentication
      end
    end
  end
end
