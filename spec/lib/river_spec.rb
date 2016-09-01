RSpec.describe River do
  describe 'River.source' do
    let(:filename) { '20160901a.zip' }
    let(:source) { River.source(filename) }

    before(:all) { Cloud::Storage.init.provider.setup }
    after(:all)  { Cloud::Storage.init.provider.teardown }

    before { Cloud::Storage.init.provider.upload(filename) }

    it 'returns an instance of River::Core' do
      expect(source).to be_a(River::Core)
    end
  end
end
