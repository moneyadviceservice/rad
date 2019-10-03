RSpec.describe AdviserQualificationsLookup do
  let(:adviser) { FactoryBot.create(:adviser, adviser_qualifications) }

  let(:qualifications) { Array.new(3) { FactoryBot.create(:qualification) } }

  let(:adviser_qualifications) do
    {
      qualifications: [qualifications.first, qualifications.last]
    }
  end

  let(:subject) { described_class.new([adviser.id]) }

  describe '#for' do
    it 'returns the qualifications for an advisor' do
      expect(subject.for(adviser.id)).to eq(
        [qualifications.first.name, qualifications.last.name]
      )
    end

    context 'when adviser has no qualifications' do
      let(:adviser) { FactoryBot.create(:adviser, qualifications: []) }

      it 'returns an empty array for that adviser' do
        expect(subject.for(adviser.id)).to eq([])
      end
    end
  end
end
