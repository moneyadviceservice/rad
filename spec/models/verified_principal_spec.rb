RSpec.describe VerifiedPrincipal, inline_job_queue: true do
  describe '#register!' do
    subject { described_class.new(form_data, 'Weyland-Yutani Ltd') }
    let(:form_data) do
      principal_attributes
        .merge(user_attributes)
        .merge(registration_type: registration_type)
    end
    let(:principal_attributes) do
      {
        fca_number: '123456',
        first_name: 'Margo',
        last_name: 'Test',
        email_address: 'test@maps.org.uk',
        job_title: 'Retirement Adviser',
        telephone_number: '2075554343',
        confirmed_disclaimer: 1
      }
    end
    let(:user_attributes) do
      {
        email: 'test@maps.org.uk',
        password: 'Password1*',
        password_confirmation: 'Password1*'
      }
    end
    let(:registration_type) { 'retirement_advice_registrations' }

    it 'creates the user, principal and associated firm' do
      expect(Stats).to receive(:increment).with('radsignup.principal.created')
      identification_mailer_double = double(Identification)
      new_firm_mailer_double = double(NewFirmMailer)
      allow(Identification)
        .to receive(:contact)
        .and_return(identification_mailer_double)
      expect(identification_mailer_double).to receive(:deliver_later)
      allow(NewFirmMailer)
        .to receive(:notify)
        .and_return(new_firm_mailer_double)
      expect(new_firm_mailer_double).to receive(:deliver_later)

      subject.register!

      expect(User.count).to eq 1
      expect(Principal.count).to eq 1
      expect(Firm.count).to eq 1

      principal = Principal.first
      expect(principal.user).to eq User.first
      expect(principal.firm).to eq Firm.first

      expect(Identification).to have_received(:contact).with(principal)
      expect(NewFirmMailer).to have_received(:notify).with(principal.firm)
    end
  end
end
