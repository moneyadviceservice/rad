RSpec.describe PreRegistrationForm, '#valid?', type: :model do
  let(:params) { nil }

  subject { described_class.new(params).valid? }

  context 'when one of the answers is missing' do
    let(:params) do {
      question_1: "1",
      question_2: "1"
    } end

    it { should be_falsy }
  end

  context 'when one or more of the answers is no' do
    let(:params) do {
      question_1: "0",
      question_2: "1",
      question_3: "1",
    } end

    it { should be_falsy }
  end

  context 'when all if the answers are yes' do
    let(:params) do {
      question_1: "1",
      question_2: "1",
      question_3: "1",
    } end

    it { should be_truthy }
  end
end
