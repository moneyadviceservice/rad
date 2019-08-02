RSpec.describe VerifiedPrincipal do
  describe '#register!' do
    subject{ described_class.new(form) }
    
    let(:response) { double(FcaApi::Response) }
    let(:principal) { double(Principal) }
    let(:form) { double(NewPrincipalForm, fca_number: '123456') }
    let(:user) { double(User, principal: Principal.new) }
    let(:user_params) { 
      {
        email: 'test@maps.org.uk',
        password: 'Password1*',
        password_confirmation: 'Password1*'
      }
    }
    let(:principal_params) {
      {
        fca_number: '123456',
        first_name: 'Margo',
        last_name: 'Test',
        email_address: 'test@maps.org.uk',
        job_title: 'Retirement Adviser',
        telephone_number: '2075554343',
        confirmed_disclaimer: 1
      }
    }

    before do
      allow(form).to receive(:user_params).and_return(user_params)
      allow(form).to receive(:principal_params).and_return(principal_params)
    end

    context 'fca number exists on the FCA register' do
      before{ allow(VerifyFrnJob).to receive(:perform_async).and_return('ABC') }
      let(:identification) { double(Identification) }

      it 'creates the user, principal and associated firm' do
        expect(User).to receive(:new).with(user_params).and_return(user)
        expect(user).to receive(:build_principal).with(principal_params)
        expect(user).to receive(:save!)
        expect(Stats).to receive(:increment).with('radsignup.principal.created')
        expect(Identification)
          .to receive(:contact)
          .with(user.principal)
          .and_return(identification)
        expect(identification).to receive(:deliver_later)
        expect(NewFirmMailer).to receive_message_chain(:notify, :deliver_later)

        subject.register!
      end
    end

    context 'fca number does not exist on the FCA register' do
      before{ allow(VerifyFrnJob).to receive(:perform_async).and_return(true) }
      let(:mailer){ double(FailedRegistrationMailer) }

      it 'sends a failed registration email to the user' do
        expect(FailedRegistrationMailer)
          .to receive(:notify)
          .with('test@maps.org.uk')
          .and_return(mailer)

        expect(mailer).to receive(:deliver_later)

        subject.register!
      end
    end
  end
end
