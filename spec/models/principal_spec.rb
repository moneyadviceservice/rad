RSpec.describe Principal do
  let(:principal) { create(:principal) }

  context 'upon creation' do
    it 'generates a token' do
      expect(principal.token).to be_present
    end
  end

  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(principal).to be_valid
    end

    describe 'FCA number' do
      it 'must be a 6 digit number' do
        expect(build(:principal, fca_number: 'DERPER')).to_not be_valid
      end

      it 'must match a `Lookup::Firm`' do
        Lookup::Firm.find_by(fca_number: principal.fca_number).destroy

        expect(principal).to_not be_valid
      end

      it 'must be unique' do
        build(:principal).tap do |p|
          p.fca_number = principal.fca_number
          expect(p).to_not be_valid
        end
      end
    end
  end
end
