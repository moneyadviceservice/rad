RSpec.describe QuestionnaireStep1Form, '#valid?', type: :model do
  let(:firm_email_address) { 'info@finsmart.com' }

  subject do
    described_class.new({
      firm_email_address: firm_email_address
    })
  end

  context 'with valid params' do
    it { is_expected.to be_valid }
  end

  describe 'firm email address' do
    context 'when missing' do
      let(:firm_email_address) { nil }

      it { is_expected.not_to be_valid }
    end

    context 'when invalid' do
      let(:firm_email_address) { 'invalid-email-format' }

      it { is_expected.not_to be_valid }
    end
  end
end
