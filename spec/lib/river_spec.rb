RSpec.describe River do
  describe 'River.source' do
    let(:filename) { '20160901a.zip' }
    let(:source) { River.source(filename) }

    before(:all) { Cloud::Storage.setup }
    after(:all)  { Cloud::Storage.teardown }

    before { Cloud::Storage.upload(filename) }

    it 'returns an instance of River::Core' do
      expect(source).to be_a(River::Core)
    end
  end
end
