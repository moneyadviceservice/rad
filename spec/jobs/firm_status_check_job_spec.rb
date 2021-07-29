RSpec.describe FirmStatusCheckJob do
  describe 'with api call' do
    include FcaTestApiCreds

    before { set_env_for_api_calls }

    let(:active_firm) { create(:firm, registered_name: 'Leek United Building Society', fca_number: 100014) }
    let(:unauthorised_firm) { create(:firm, registered_name: 'Davies Watson', fca_number: 100044) }
    let(:unknown_firm) { create(:firm, registered_name: 'Beasts', fca_number: 666666) }

    def use_cassette(name)
      VCR.use_cassette("firm-status-check-job-#{name}") { yield }
    end

    def perform_now(firm)
      described_class.perform_now(firm)
    end

    def check_inactive_firm_creation(count = 1)
      expect { yield }.to change { InactiveFirm.count }.by count
    end

    context 'an inactive_firm record' do
      it 'is created if firm exists with inactive status' do
        use_cassette(:inactive) do
          check_inactive_firm_creation { perform_now(unauthorised_firm) }
        end
      end

      it 'is created if firm does not exist' do
        use_cassette(:unknown) do
          check_inactive_firm_creation { perform_now(unknown_firm) }
        end
      end

      it 'is not created if firm exists with active status' do
        use_cassette(:active) do
          check_inactive_firm_creation(0) { perform_now(active_firm) }
        end
      end
    end

    context 'field of inactive_firm record' do
      it 'has correct value if firm exists with inactive status' do
        use_cassette(:inactive) do
          perform_now(unauthorised_firm)

          if inactive_firm = InactiveFirm.last
            expect(inactive_firm.firmable).to eq unauthorised_firm

            expect(inactive_firm.api_status).to eq 'No longer authorised'
          end
        end
      end

      it 'has correct value if firm does not exist' do
        use_cassette(:unknown) do
          perform_now(unknown_firm)

          if inactive_firm = InactiveFirm.last
            expect(inactive_firm.firmable).to eq unknown_firm

            expect(inactive_firm.api_status).to eq 'Not Found'
          end
        end
      end
    end

    context 'failures when calling api' do
    end
  end

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
