RSpec.describe FcaApi::Response do
  subject { described_class.new(response) }

  let(:response) do
    instance_double(Faraday::Response, body: api_response)
  end

  describe '#ok?' do
    context 'successful response' do
      let(:api_response) { { 'Message' => 'Ok. Firm Found' } }

      it 'returns true' do
        expect(subject.ok?).to be_truthy
      end
    end

    context 'bad response' do
      let(:api_response) { { 'Message' => 'Firm not found' } }

      it 'returns false' do
        expect(subject.ok?).to be_falsey
      end
    end
  end

  describe '#data' do
    let(:api_response) do
      {
        'Message' => 'Firm not found',
        'Data' => [{ 'Organisation Name' => 'xyz' }]
      }
    end

    it 'returns the firm data' do
      expect(subject.data).to eq('Organisation Name' => 'xyz')
    end
  end
end
