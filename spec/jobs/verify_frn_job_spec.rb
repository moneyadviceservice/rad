RSpec.describe VerifyFrnJob do
  describe '#perform' do
    let(:frn) { '123456' }
    let(:response) { double(FcaApi::Response, ok?: true, data: data) }
    let(:data) { { 'data' => [{ 'Organisation Name' => 'ABC' }] } }
    
    it 'calls the FCA API' do
      expect(FcaApi::Request)
        .to receive_message_chain(:new, :get_firm)
        .with('123456')
        .and_return(response)

      VerifyFrnJob.perform_now(frn)
    end
  end
end
