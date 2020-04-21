RSpec.describe TravelInsurance::MedicalConditionsForm, '#valid?', type: :model do
  let(:params) { nil }

  subject { described_class.new(params) }

  context 'when all questions are answered and valid' do
    let(:params) do
      {
        covers_medical_condition_question: 'all',
      }
    end

    it { is_expected.to be_valid }
  end

  describe "#reject?" do
    context "should return false irrelevant of answer" do
      let(:params) { { covers_medical_condition_question: 'one_specific' } }
      it { is_expected.not_to be_reject }
    end
  end

  describe "#complete?" do
    context "true when form is valid and covers_medical_condition_question is 'one_specific'" do
      let(:params) { { covers_medical_condition_question: 'one_specific' } }
      it { is_expected.to be_complete }
    end

    context "false when the form is valid and covers_medical_condition_question is 'all'" do
      let(:params) { { covers_medical_condition_question: 'all' } }
      it { is_expected.not_to be_complete }
    end
  end
end
