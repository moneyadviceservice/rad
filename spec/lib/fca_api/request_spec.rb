RSpec.describe FcaApi::Request do
  subject { described_class.new }

  let(:connection) { FcaApi::Connection.new(domain) }
  let(:domain) { 'http://fca.org.uk' }
  let(:firm_id) { 100_001 }
  let(:response) { instance_double(Faraday::Response) }

  before do
    stub_env('FCA_API_DOMAIN', domain)
    stub_env('FCA_API_MAX_RETRIES', 2)
    stub_env('FCA_API_TIMEOUT', 1)
    stub_env('FCA_API_EMAIL', 'email@maps.org.uk')
    stub_env('FCA_API_KEY', 'xyz123abc')
    allow(FcaApi::Connection)
      .to receive(:new)
      .with(domain)
      .and_return(connection)
  end

  describe '#get_firm' do
    let(:response_message) { { 'Message' => 'Ok. Firm Found' } }
    it 'returns a firm with the provided reference number' do
      expect(connection)
        .to receive(:get)
        .with("/services/V0.1/Firm/#{firm_id}")
        .and_return(response)

      expect(FcaApi::Response).to receive(:new).with(response)

      subject.get_firm(firm_id)
    end
  end

  private

  def stub_env(key, value)
    allow(ENV).to receive(:fetch).with(key).and_return(value)
  end
end
