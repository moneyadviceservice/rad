RSpec.describe TravelInsurance::RiskProfileForm, '#valid?', type: :model do
  let(:params) { nil }

  subject { described_class.new(params) }

  context 'when all questions are answered and valid' do
    let(:params) do
      {
        covered_by_ombudsman_question: '1',
        risk_profile_approach_question: 'bespoke'
      }
    end

    it { is_expected.to be_valid }
  end

  context "when not all questions are answered" do
    let(:params) { { covered_by_ombudsman_question: '1' } }
    it { is_expected.not_to be_valid }
  end

  describe "#reject?" do
    context "when form is valid but risk_profile_question is 'neither'" do
      let(:params) { { covered_by_ombudsman_question: '1', risk_profile_approach_question: 'neither' } }
      it { is_expected.to be_reject }
    end

    context "when form is valid but risk_profile_question is any other than 'neither'" do
      let(:params) { { covered_by_ombudsman_question: '1', risk_profile_approach_question: 'questionaire' } }
      it { is_expected.not_to be_reject }
    end
  end

  describe "#complete?" do
    context "when form is valid and risk_profile_approach_question is 'bespoke'" do
      let(:params) { { covered_by_ombudsman_question: '1', risk_profile_approach_question: 'bespoke' } }
      it { is_expected.to be_complete }
    end

    context "when form is valid and risk_profile_approach_question is other than 'bespoke'" do
      let(:params) { { covered_by_ombudsman_question: '1', risk_profile_approach_question: 'questionaire' } }
      it { is_expected.not_to be_complete }
    end
  end
end
