RSpec.describe VerifyFrnJob do
  describe '#perform' do
    let(:params) do
      {
        fca_number: '123456',
        first_name: 'First',
        last_name: 'Last',
        job_title: 'Job',
        email: 'ex@ample.com',
        telephone_number: '0780000000',
        confirmed_disclaimer: '1',
        password: 'Password1!',
        password_confirmation: 'Password1!'
      }
    end

    let(:form) { NewPrincipalForm.new(params)}
    let(:response) { double(FcaApi::Response, ok?: true) }
    
    it 'calls the FCA API' do
      expect(FcaApi::Request)
        .to receive_message_chain(:new, :get_firm)
        .with('123456')
        .and_return(response)

      VerifyFrnJob.perform_now(form)
    end
  end
end
