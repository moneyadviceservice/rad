RSpec.describe AdviserListCsv do
  describe '#to_csv' do
    let(:adviser1) { FactoryGirl.create(:adviser, adviser1_certifications) }
    let(:adviser2) { FactoryGirl.create(:adviser, adviser2_certifications) }
    let(:advisers) { [adviser1, adviser2] }

    let(:qualifications) { 3.times.map { FactoryGirl.create(:qualification) } }
    let(:accreditations) { 3.times.map { FactoryGirl.create(:accreditation) } }

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

    let(:subject)  { described_class.new(advisers) }

    it 'responds to csv conversion' do
      expect(described_class.new([])).to respond_to(:to_csv)
    end

    context 'when csv is generated' do
      let(:table)    { CSV.parse(subject.to_csv) }
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

    context 'Office' do
      it 'should not respond to csv conversion' do
        expect(Office).to_not respond_to(:to_csv)
      end
    end
  end
end
