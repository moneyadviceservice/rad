RSpec.describe Firm do
  subject(:firm) { build(:firm) }

  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(firm).to be_valid
    end

    describe 'email address' do
      context 'when not present' do
        before { firm.email_address = nil }

        it { is_expected.to_not be_valid }
      end

      context 'when badly formatted' do
        before { firm.email_address = 'not-valid' }

        it { is_expected.to_not be_valid }
      end
    end

    describe 'telephone number' do
      context 'when not present' do
        before { firm.telephone_number = nil }

        it { is_expected.to_not be_valid }
      end

      context 'when badly formatted' do
        before { firm.telephone_number = 'not-valid' }

        it { is_expected.to_not be_valid }
      end
    end

    describe 'address line 1' do
      context 'when missing' do
        before { firm.address_line_1 = nil }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'address line 2' do
      context 'when missing' do
        before { firm.address_line_2 = nil }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'address town' do
      context 'when missing' do
        before { firm.address_town = nil }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'address county' do
      context 'when missing' do
        before { firm.address_county = nil }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'address postcode' do
      context 'when missing' do
        before { firm.address_postcode = nil }

        it { is_expected.not_to be_valid }
      end

      context 'when invalid' do
        before { firm.address_postcode = nil }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'service regions' do
      context 'when none assigned' do
        before { firm.service_regions = [] }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'in person advice methods' do
      context 'when none assigned' do
        before { firm.in_person_advice_methods = [] }

        it { is_expected.not_to be_valid }
      end
    end
  end
end
