RSpec.describe InactiveFirms::CheckApproved do
  include FcaApiExtractCreds

  before { set_env_for_api_calls }

  let(:approved__firm) { create(:firm, registered_name: 'Leek United Building Society', fca_number: 100014) }
  let(:unauthorised_firm) { create(:firm, registered_name: 'Davies Watson', fca_number: 100044) }
  let(:unknown_firm) { create(:firm, registered_name: 'Beasts', fca_number: 666666) }

  def use_cassette(name)
    VCR.use_cassette("inactive-firms-check-approved-#{name}") { yield }
  end

  context 'successful API call' do
    it 'has approved status' do
      use_cassette(:authorised) do
        subject.call(approved__firm.fca_number)

        expect(subject.failure?).to be_falsey

        expect(subject.valid?).to be_truthy
      end
    end

    it 'has unapproved status' do
      use_cassette(:unauthorised) do
        subject.call(unauthorised_firm.fca_number)

        expect(subject.failure?).to be_falsey

        expect(subject.valid?).to be_falsey

        expect(subject.fca_status).to match(/No longer authorised/i)
      end
    end

    it 'is not found' do
      use_cassette(:unknown) do
        subject.call(unknown_firm.fca_number)

        expect(subject.failure?).to be_falsey

        expect(subject.valid?).to be_falsey

        expect(subject.fca_status).to match(/Not Found/i)
      end
    end
  end

  context 'unsuccessful API call' do
    it 'flags failure when API returns error message' do
      use_cassette(:failure) do
        set_env_var('FCA_API_KEY', '8c5e94fd07d788dfbdf14fcb6c799999')

        subject.call(approved__firm.fca_number)

        expect(subject.failure?).to be_truthy
      end
    end

    it 'flags failure when API throws exception' do
      use_cassette(:exception) do
        set_env_var('FCA_API_TIMEOUT', '0')

        subject.call(approved__firm.fca_number)

        expect(subject.failure?).to be_truthy
      end
    end

    it 'flags failure when API in maintenance mode' do
      allow(subject.send(:request).connection).to receive(:get).and_raise(Faraday::ParsingError.new({}))

      use_cassette(:maintenance) do
        subject.call(approved__firm.fca_number)

        expect(subject.failure?).to be_truthy
      end
    end
  end
end
