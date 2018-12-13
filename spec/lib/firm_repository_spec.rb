RSpec.describe FirmRepository do
  let(:client) { double }
  let(:client_class) { double(new: client) }

  describe 'initialization' do
    subject { described_class.new }

    it 'defaults `client`' do
      expect(subject.client).to be_a(ElasticSearchClient)
    end

    it 'defaults `serializer`' do
      expect(subject.serializer).to eql(FirmSerializer)
    end
  end

  describe '#store' do
    let(:firm) { create(:firm) }

    it 'delegates to the configured client' do
      expect(client).to receive(:store).with(/firms\/\d+/, hash_including(:_id))

      described_class.new(client_class).store(firm)
    end
  end

  describe '#delete' do
    it 'delegates to the configured client' do
      expect(client).to receive(:delete).with('firms/1')

      described_class.new(client_class).delete(1)
    end
  end
end
