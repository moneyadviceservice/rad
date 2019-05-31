RSpec.describe FcaApi::Connection do
  let(:mock_raw_connection) { double(Faraday) }
  let(:domain) { 'http://test-domain/'}

  before do
    stub_env('FCA_API_MAX_RETRIES', 2)
    stub_env('FCA_API_TIMEOUT', 1)
    stub_env('FCA_API_EMAIL', 'email@maps.org.uk')
    stub_env('FCA_API_KEY', 'xyz123abc')
    expect(Faraday).to receive(:new)
      .with(
        domain,
        request: { timeout: 1 },
        headers: {
          'X-Auth-Email' => 'email@maps.org.uk',
          'X-Auth-Key' => 'xyz123abc'
        },
      )
      .and_return(mock_raw_connection)
  end

  describe '.new' do
    it 'initialises with some configuration and sets up a raw connection' do
      connection = described_class.new(domain)

      expect(connection.domain).to eq domain
      expect(connection.timeout).to eq 1
      expect(connection.retries).to eq 2
      expect(connection.raw_connection).to eq mock_raw_connection
    end
  end

  describe '#get' do
    it 'delegates to the raw_connection with the provided path' do
      connection = described_class.new(domain)
      expect(mock_raw_connection).to receive(:get).with('/path/100023')

      connection.get('/path/100023')
    end
  end

  private

  def stub_env(key, value)
    allow(ENV).to receive(:fetch).with(key).and_return(value)
  end
end
