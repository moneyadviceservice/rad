RSpec.describe Principal do
  context 'upon creation' do
    it 'generates a token' do
      expect(described_class.create.token).to be_present
    end
  end
end
