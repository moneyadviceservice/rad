RSpec.describe VerifyReferenceNumberJob do
  describe '#perform' do
    let(:form_data) do
      {
        'fca_number' => '123456',
        'first_name' => 'Margo',
        'last_name' => 'Test',
        'job_title' => 'Adviser',
        'email' => 'test@maps.org.uk',
        'telephone_number' => '2075554343',
        'password' => 'Password1*',
        'password_confirmation' => 'Password1*',
        'confirmed_disclaimer' => '1'
      }
    end

    let(:request) { FcaApi::Request }
    let(:response) { double(FcaApi::Response, ok?: result, data: data) }
    let(:mailer) { double(FailedRegistrationMailer) }
    let(:verified_principal) { double(VerifiedPrincipal) }

    before do
      expect(request)
        .to receive_message_chain(:new, :get_firm)
        .with('123456')
        .and_return(response)
    end

    context 'successfully response from the api' do
      let(:result) { true }
      let(:data) { { 'Organisation Name' => 'ABC' } }

      it 'calls the FCA API' do
        expect(VerifiedPrincipal)
          .to receive(:new)
          .with(form_data, 'ABC')
          .and_return(verified_principal)

        expect(verified_principal).to receive(:register!)

        described_class.perform_now(form_data)
      end
    end

    context 'failed response from the api' do
      let(:result) { false }
      let(:data) { nil }

      it 'calls the FCA API' do
        expect(FailedRegistrationMailer)
          .to receive(:notify)
          .with('test@maps.org.uk')
          .and_return(mailer)

        expect(mailer).to receive(:deliver_later)

        described_class.perform_now(form_data)
      end
    end
  end
end
