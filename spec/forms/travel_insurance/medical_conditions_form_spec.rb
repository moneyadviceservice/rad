RSpec.describe TravelInsurance::MedicalConditionsForm, '#valid?', type: :model do
  let(:params) { nil }

  subject { described_class.new(params) }

  context 'when not all questions are answered' do
    let(:params) { {} }
    it { is_expected.not_to be_valid }
  end

  context 'when all questions are answered and valid' do
    let(:params) do
      {
        covers_medical_condition_question: 'all'
      }
    end

    it { is_expected.to be_valid }
  end
end
