RSpec.describe AdviserListCsv do
  describe '#to_csv' do
    let(:adviser1) { FactoryBot.create(:adviser, adviser1_certifications) }
    let(:adviser2) { FactoryBot.create(:adviser, adviser2_certifications) }
    let(:advisers) { [adviser1, adviser2] }

    let(:qualifications) { Array.new(3) { FactoryBot.create(:qualification) } }
    let(:accreditations) { Array.new(3) { FactoryBot.create(:accreditation) } }

    let(:adviser1_certifications) do
      {
        qualifications: [qualifications.first, qualifications.last],
        accreditations: [accreditations.first]
      }
    end
    let(:adviser2_certifications) do
      {
        qualifications: [qualifications.last],
        accreditations: [accreditations.last]
      }
    end

    subject(:adviser_list) { described_class.new(advisers) }

    it 'responds to csv conversion' do
      expect(described_class.new([])).to respond_to(:to_csv)
    end

    context 'when csv is generated' do
      let(:table)    { CSV.parse(adviser_list.to_csv) }
      let(:headings) { table[0] }
      let(:row1)     { table[1] }
      let(:row2)     { table[2] }

      it 'returns csv headings' do
        expect(headings).to eq(
          [
            'Ref. Number',
            'Name',
            'Firm'
          ] + Qualification.pluck(:name) + Accreditation.pluck(:name)
        )
      end

      it 'returns data for each adviser' do
        expect(row1).to eq([
                             adviser1.reference_number,
                             adviser1.name,
                             adviser1.firm.registered_name,
                             'Y', 'N', 'Y', 'Y', 'N', 'N'
                           ])

        expect(row2).to eq([
                             adviser2.reference_number,
                             adviser2.name,
                             adviser2.firm.registered_name,
                             'N', 'N', 'Y', 'N', 'N', 'Y'
                           ])
      end
    end
  end
end
