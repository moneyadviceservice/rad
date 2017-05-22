RSpec.describe AdviserListCsv do
  describe '#to_csv' do
    it 'responds to csv conversion' do
      expect(described_class.new []).to respond_to(:to_csv)
    end
  end

  context 'Office' do
    it 'should not respond to csv conversion' do
      expect(Office).to_not respond_to(:to_csv)
    end
  end
end
