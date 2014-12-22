RSpec.describe Principal do
  context 'upon creation' do
    it 'generates a token' do
      expect(FactoryGirl.create(:principal).token).to be_present
    end
  end

  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(FactoryGirl.create(:principal)).to be_valid
    end

    describe 'FCA number' do
      it 'must be a 6 digit number' do
        expect(described_class.new(fca_number: 'DERPER')).to_not be_valid
      end

      it 'must match a `Lookup::Firm`' do
        principal = FactoryGirl.create(:principal)
        Lookup::Firm.find_by(fca_number: principal.fca_number).destroy

        expect(principal).to_not be_valid
      end
    end
  end
end
