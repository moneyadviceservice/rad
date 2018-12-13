RSpec.describe Lookup::Firm do
  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(
        described_class.new(fca_number: 123_456, registered_name: 'Ben Lovell Ltd')
      ).to be_valid
    end

    describe 'FCA Number rules' do
      it 'accepts numeric' do
        expect(described_class.new(fca_number: '123A45')).to_not be_valid
      end

      it 'accepts only 6 digits' do
        expect(described_class.new(fca_number: 1_234_567)).to_not be_valid
      end
    end
  end
end
