RSpec.describe AdviserAccreditationsLookup do
  let(:adviser) { FactoryGirl.create(:adviser, adviser_accreditations) }

  let(:accreditations) { Array.new(3) { FactoryGirl.create(:accreditation) } }

  let(:adviser_accreditations) do
    {
      accreditations: [accreditations.first, accreditations.last]
    }
  end

  let(:subject) { described_class.new([adviser.id]) }

  describe '#for' do
    it 'returns the accreditations for an adviser' do
      expect(subject.for(adviser.id)).to eq(
        [accreditations.first.name, accreditations.last.name]
      )
    end

    context 'when adviser has no accreditations' do
      let(:adviser) { FactoryGirl.create(:adviser, accreditations: []) }

      it 'returns an empty array for that adviser' do
        expect(subject.for(adviser.id)).to eq([])
      end
    end
  end
end
