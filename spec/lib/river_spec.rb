RSpec.describe River do
  describe 'River.source' do
    it 'returns an instance of River::Core' do
      expect(River.source).to be_a(River::Core)
    end
  end
end
