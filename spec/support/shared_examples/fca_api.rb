RSpec.shared_examples 'an fca api' do |lookup_type|
  include FcaApiExtractCreds

  before { set_env_for_api_calls }

  let(:request) { FcaApi::Request.new }

  let(:lookup_method) { :"get_#{lookup_type}" }

  let(:cassette_name_root) { 'fca-api-request-' + lookup_type }

  let(:good_cassette_name) { cassette_name_root + '-good' }
  let(:bad_cassette_name) { cassette_name_root + '-bad' }
  let(:failure_cassette_name) { cassette_name_root + '-failure' }
  let(:exception_cassette_name) { cassette_name_root + '-exception' }

  def response(key)
    request.send(lookup_method, key)
  end

  context 'for ' + lookup_type do
    it 'verifies a valid key' do
      VCR.use_cassette(good_cassette_name) do
        response = response(lookup_key)

        expect(response.ok?).to be_truthy
      end
    end

    it 'retrieves data items by name' do
      VCR.use_cassette(good_cassette_name) do
        response = response(lookup_key)

        expected_fields.each do |name, value|
          expect(response.data[name]).to eq value
        end
      end
    end

    it 'rejects an invalid key' do
      VCR.use_cassette(bad_cassette_name) do
        response = response(bad_lookup_key)

        expect(response.ok?).to_not be_truthy
      end
    end

    context 'api failures' do
      it 'down for maintenance' do
        allow(request.connection).to receive(:get).and_raise(Faraday::ParsingError.new({}))

        response = response(lookup_key)

        expect(response.ok?).to_not be_truthy
      end

      it 'returns failure message' do
        VCR.use_cassette(failure_cassette_name) do
          set_env_var('FCA_API_KEY', '8c5e94fd07d788dfbdf14fcb6c799999')

          response = response(lookup_key)

          expect(response.ok?).to_not be_truthy
        end
      end

      it 'throws exception' do
        VCR.use_cassette(exception_cassette_name) do
          set_env_var('FCA_API_TIMEOUT', '0')

          expect { response(lookup_key) }.to raise_error(Faraday::ConnectionFailed)
        end
      end
    end
  end
end
