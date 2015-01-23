RSpec.describe Adviser do
  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(build(:adviser)).to be_valid
    end

    describe 'reference number' do
      it 'is required' do
        expect(build(:adviser, reference_number: nil)).to_not be_valid
      end

      it 'must be three characters and five digits exactly' do
        %w(badtimes ABCDEFGH 8008135! 12345678).each do |bad|
          Lookup::Adviser.create!(reference_number: bad, name: 'Mr. Derp')

          expect(build(:adviser, reference_number: bad)).to_not be_valid
        end
      end

      it 'must be matched to the lookup data' do
        build(:adviser, reference_number: 'ABC12345').tap do |a|
          Lookup::Adviser.delete_all

          expect(a).to_not be_valid
        end
      end
    end
  end
end
