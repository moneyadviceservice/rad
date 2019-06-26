RSpec.describe FcaApi::Response do
  subject { described_class.new(response) }

  let(:response) do
    instance_double(Faraday::Response, body: { 'Message' => response_message })
  end

  describe '#ok?' do
    context 'successful response' do
      let(:response_message) { 'Ok. Firm Found' }

      it 'returns true' do
        expect(subject.ok?).to be_truthy
      end
    end

    context 'bad response' do
      let(:response_message) { 'Firm not found' }

      it 'returns false' do
        expect(subject.ok?).to be_falsey
      end
    end
  end
end
