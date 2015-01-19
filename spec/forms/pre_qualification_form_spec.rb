RSpec.describe PreQualificationForm, '#valid?', type: :model do
  let(:params) { nil }

  subject { described_class.new(params) }

  context 'when one of the answers is missing' do
    let(:params) do {
      question_1: '1',
      question_2: '1'
    } end

    it { is_expected.not_to be_valid }
  end

  context 'when one or more of the answers is no' do
    let(:params) do {
      question_1: '0',
      question_2: '1',
      question_3: '1',
    } end

    it { is_expected.not_to be_valid }
  end

  context 'when all answers are yes' do
    let(:params) do {
      question_1: '1',
      question_2: '1',
      question_3: '1',
      question_4: '1'
    } end

    it { is_expected.to be_valid }
  end
end
