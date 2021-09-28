RSpec.describe SuccessfulRegistrationMailer, '#contact' do
  let(:principal) { create(:principal) }
  subject { described_class.contact(principal, registration_type) }

  context 'retirement advice registrations' do
    let(:registration_type) { 'retirement_advice_registrations' }

    it 'has a subject' do
      expect(subject.subject).to be_present
    end

    it 'has a from address' do
      expect(subject.from.first).to eq('RADenquiries@moneyhelper.org.uk')
    end

    it 'addressed to the principal' do
      expect(subject.to).to contain_exactly(principal.email_address)
    end

    describe 'body' do
      it 'contains self service url' do
        expect(subject.body.decoded).to include(new_user_session_path)
      end
    end
  end

  context 'travel insurance registrations' do
    let(:registration_type) { 'travel_insurance_registrations' }

    it 'has a subject' do
      expect(subject.subject).to be_present
    end

    it 'has a from address' do
      expect(subject.from.first).to eq('RADenquiries@moneyhelper.org.uk')
    end

    it 'addressed to the principal' do
      expect(subject.to).to contain_exactly(principal.email_address)
    end

    describe 'body' do
      it 'contains self service url' do
        # expect(subject.body.decoded).to include(new_user_session_path)
      end
    end
  end
end
