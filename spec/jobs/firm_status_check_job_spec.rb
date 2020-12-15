RSpec.describe FirmStatusCheckJob do
  describe '#perform' do
    let(:invalid_firm) { double(InvalidFirm) }
    let(:request) { FcaApi::Request }
    let(:response) { double(FcaApi::Response, ok?: result, data: data) }

    before do
      expect(request)
        .to receive_message_chain(:new, :get_firm)
        .with(firm.fca_number)
        .and_return(response)
    end

    context 'successful response from the api' do
      let(:firm) { FactoryBot.create(:firm, registered_name: 'Acme Finance', fca_number: 100013) }
      let(:result) { true }

      context 'the firm is active' do
        let(:data) { { 'Status' => 'Active', 'FRN' => firm.fca_number } }

        it 'creates an Inactive Firm' do
          expect(InactiveFirm).to_not receive(:create).with(api_status: 'Inactive', firmable: firm)

          described_class.perform_now(firm)
        end
      end

      context 'the firm is inactive' do
        let(:data) { { 'Status' => 'Inactive', 'FRN' => firm.fca_number } }

        it 'creates an Inactive Firm' do
          expect(InactiveFirm).to receive(:create).with(api_status: 'Inactive', firmable: firm)

          described_class.perform_now(firm)
        end
      end
    end

    context 'failed response from the api' do
      let(:firm) { FactoryBot.create(:firm, registered_name: 'Acme Finance', fca_number: 10001) }
      let(:result) { false }
      let(:data) { nil }

      it 'creates an Inactive Firm' do
        expect(InactiveFirm).to receive(:create).with(api_status: 'Not Found', firmable: firm)

        described_class.perform_now(firm)
      end
    end
  end
end
