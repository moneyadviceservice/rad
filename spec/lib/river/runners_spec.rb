RSpec.describe River::Runners do
  subject     { River::Runners }
  let(:fetch) { subject.fetch(runner) { callback } }

  describe '.fetch' do
    context 'when fetching tempfile runner' do
      let(:runner) { :tempfile }
      it 'return a runner' do
        expect(fetch).to be_present
      end
    end
  end

  describe '.all' do
    it 'returns all defined runners' do
      expect(subject.all).to match_array [:tempfile]
    end
  end
end
