RSpec.describe AdviserCsvLookup do
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

  before do
    subject.build!
  end

  describe '#build!' do
    it 'returns data for qualifications_lookup' do
      expect(subject.qualifications_lookup).to eq(
        adviser1.id => [qualifications.first.name, qualifications.last.name],
        adviser2.id => [qualifications.last.name]
      )
    end

    it 'returns data for accreditations_lookup' do
      expect(subject.accreditations_lookup).to eq(
        adviser1.id => [accreditations.first.name],
        adviser2.id => [accreditations.last.name]
      )
    end

    it 'returns data for firms_lookup' do
      expect(subject.firms_lookup).to eq(
        adviser1.firm_id => adviser1.firm.registered_name,
        adviser2.firm_id => adviser2.firm.registered_name
      )
    end
  end

  describe '#certifications_list' do
    let(:expected_qualifications) { qualifications.map(&:name) }
    let(:expected_accreditations) { accreditations.map(&:name) }

    it 'returns a list of all the certifications' do
      expect(subject.certification_list).to eq(
        expected_qualifications + expected_accreditations
      )
    end
  end
end
