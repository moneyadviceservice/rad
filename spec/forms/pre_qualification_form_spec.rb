RSpec.describe PreQualificationForm, '#valid?', type: :model do
  let(:params) { nil }

  subject { described_class.new(params) }

  context 'when only question 4 is answered' do
    let(:params) {{ status_question: '1' }}

    it { is_expected.not_to be_valid }
  end

  context 'when one of the answers is missing' do
    let(:params) {{ active_question: '1'}}

    it { is_expected.not_to be_valid }
  end

  context 'when one or more of the answers is no' do
    let(:params) {{ active_question: '0', business_model_question: '1' }}

    it { is_expected.not_to be_valid }
  end

  context 'when all answers are yes' do
    let(:params) do
      {
        active_question: '1',
        business_model_question: '1',
        status_question: '1'
      }
    end

    it { is_expected.to be_valid }
  end

  context 'when status restricted, focuses on market yet providers are no' do
    let(:params) do
      {
        active_question: '1',
        business_model_question: '1',
        status_question: '0',
        particular_market_question: '1',
        consider_available_providers_question: '0'
      }
    end

    it { is_expected.not_to be_valid }
  end
end
