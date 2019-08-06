RSpec.describe VerifiedPrincipal do
  describe '#register!' do
    subject{ described_class.new(form_data, 'ABC') }
    
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
    let(:principal) { double(Principal) }
    let(:form_data) { principal_params.merge(user_params) }
    let(:form) { NewPrincipalForm.new(form_data) }
    let(:user) { double(User, principal: Principal.new) }
    let(:identification) { double(Identification) }

    it 'creates the user, principal and associated firm' do
      expect(NewPrincipalForm).to receive(:new).and_return(form)
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
end
