RSpec.describe CreateInactiveFirmsJob do
  include FcaApiExtractCreds

  before { set_env_for_api_calls }

  let(:approved_firm) { create(:firm, registered_name: 'Leek United Building Society', fca_number: 100014) }
  let(:unauthorised_firm) { create(:firm, registered_name: 'Davies Watson', fca_number: 100044) }
  let(:unknown_firm) { create(:firm, registered_name: 'Beasts', fca_number: 666666) }

  let(:firms) { [approved_firm, unauthorised_firm, unknown_firm] }

  let(:inactive_firms) { InactiveFirm.order(:id).to_a }

  let(:any_old_firm) { create(:firm, parent_id: 999) }
  let(:inactive_firm) { InactiveFirm.create(firmable: any_old_firm, api_status: 'Symbol') }

  def use_cassette(name)
    VCR.use_cassette("create-inactive-firms-job-#{name}") { yield }
  end

  def perform_job
    described_class.perform_now
  end

  context 'successful api calls' do
    before { firms }

    it 'creates two inactive_firm records' do
      use_cassette(:all) do
        expect { perform_job }.to change { InactiveFirm.count }.by 2
      end
    end

    it 'creates correctly valued inactive_firm records for unauthorised firms' do
      use_cassette(:all) do
        perform_job

        expect(inactive_firms.map(&:firmable)).to eq firms[1..-1]
      end
    end
  end

  context 'unsuccessful api call' do
    def expect_db_restoration(mode)
      inactive_firm

      use_cassette(mode) do
        yield

        approved_firm

        perform_job
      end

      expect(inactive_firms).to eq [inactive_firm]
    end

    it 'reverts inactive_firms table to original state if API produces an error' do
      expect_db_restoration(:failure) do
        allow_any_instance_of(described_class).to receive(:add_inactive_firm_if_unapproved).and_return(false)
      end
    end

    it 'reverts inactive_firms table to original state if API returns an error' do
      expect_db_restoration(:error) do
        set_env_var('FCA_API_KEY', '8c5e94fd07d788dfbdf14fcb6c799999')
      end
    end

    it 'reverts inactive_firms table to original state if API throws an error' do
      expect_db_restoration(:exception) do
        set_env_var('FCA_API_TIMEOUT', '0')
      end
    end
  end
end
