RSpec.describe River::Core do
  let(:filename) { '20160901a.zip' }
  let(:river)    { River.source }

  describe 'River.source' do
    it 'returns itself' do
      expect(river).to be_a(River::Core)
    end
  end

  describe '.step' do
    let(:upcase) { ->(r, w, _) { w.write(r.read.upcase) } }

    it 'adds a object that responds to .call' do
      river.step(&upcase)
      expect(river.commands.count).to eq(1)
    end
  end

  describe '.sink' do
    it 'fetches a runner' do
      expect(River::Runners).to receive(:fetch).with(:tempfile).and_return(proc {})
      river.sink
    end
  end
end
