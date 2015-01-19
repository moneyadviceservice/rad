RSpec.describe PreQualificationForm, '#valid?', type: :model do
  let(:params) { nil }

  subject { described_class.new(params) }

  context 'when only question 4 is answered' do
    let(:params) {{ firm_status_question: '1' }}

    it { is_expected.not_to be_valid }
  end

  context 'when one of the answers is missing' do
    let(:params) {{ firm_active_question: '1'}}

    it { is_expected.not_to be_valid }
  end

  context 'when one or more of the answers is no' do
    let(:params) {{ firm_active_question: '0', firm_business_model_question: '1' }}

    it { is_expected.not_to be_valid }
  end

  context 'when all answers are yes' do
    let(:params) do
      {
        firm_active_question: '1',
        firm_business_model_question: '1',
        firm_status_question: '1'
      }
    end

    it { is_expected.to be_valid }
  end
end
