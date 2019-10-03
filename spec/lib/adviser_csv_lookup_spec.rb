RSpec.describe AdviserCsvLookup do
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

  let(:subject) { described_class.new(advisers) }

  describe '#each' do
    let(:expected_adviser_1_data) do
      {
        adviser:        adviser1,
        firm_name:      adviser1.firm.registered_name,
        qualifications: adviser1.qualifications.map(&:name),
        accreditations: adviser1.accreditations.map(&:name)
      }
    end
    let(:expected_adviser_2_data) do
      {
        adviser:        adviser2,
        firm_name:      adviser2.firm.registered_name,
        qualifications: adviser2.qualifications.map(&:name),
        accreditations: adviser2.accreditations.map(&:name)
      }
    end
    it 'yields for each adviser with the additional data for that adviser' do
      expect { |b| subject.each(&b) }
        .to yield_successive_args(
          expected_adviser_1_data, expected_adviser_2_data
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
