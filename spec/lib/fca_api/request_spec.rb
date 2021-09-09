RSpec.describe FcaApi::Request do
  subject { described_class.new }

  let(:connection) { FcaApi::Connection.new(domain) }
  let(:domain) { 'https://www.fca.org.uk' }
  let(:firm_id) { 100_001 }
  let(:response) { instance_double(Faraday::Response) }
  let(:response_failed) { instance_double(FcaApi::Response) }

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

  describe '#get_individual' do
    let(:response_message) { { 'Message' => 'Ok. Individual found' } }

    it 'returns an individual with the provided reference number' do
      expect(connection)
        .to receive(:get)
        .with('/services/V0.1/Individuals/123')
        .and_return(response)

      expect(FcaApi::Response).to receive(:new).with(response)

      subject.get_individual('123')
    end
  end

  describe 'API down for maintenance' do
    # rubocop:disable Style/HashSyntax
    let(:response_failure_message) { { :Message => 'Failure' } }
    # rubocop:enable Style/HashSyntax
    let(:down_for_maintenance) { { 'Success' => 'true', 'Message' => 'API down' } }

    it 'returns a failed response' do
      allow(connection)
        .to receive(:get)
        .and_raise(Faraday::ParsingError.new(down_for_maintenance))

      allow(Faraday::Response).to receive(:new).with(body: response_failure_message).and_return(response)

      expect(FcaApi::Response).to receive(:new).with(response).and_return(response_failed)

      subject.get_firm(firm_id)
    end
  end

  private

  def stub_env(key, value)
    allow(ENV).to receive(:fetch).with(key).and_return(value)
  end
end
