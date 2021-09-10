RSpec.describe TravelInsurance::RiskProfileForm, '#valid?', type: :model do
  let(:params) { nil }

  subject { described_class.new(params) }

  context 'when all questions are answered and valid' do
    let(:params) do
      {
        covered_by_ombudsman_question: 'true',
        risk_profile_approach_question: 'bespoke',
        supplies_documentation_when_needed_question: 'true'
      }
    end

    it { is_expected.to be_valid }
  end

  context 'when not all questions are answered' do
    let(:params) { { supplies_documentation_when_needed_question: 'true' } }
    it { is_expected.not_to be_valid }
  end
end
