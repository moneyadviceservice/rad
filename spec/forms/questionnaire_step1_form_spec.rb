RSpec.describe QuestionnaireStep1Form, '#valid?', type: :model do
  let(:firm_email_address) { 'info@finsmart.com' }
  let(:firm_telephone_number) { '0300 500 5000' }

  subject do
    described_class.new({
      firm_email_address: firm_email_address,
      firm_telephone_number: firm_telephone_number
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

  describe 'firm telephone number' do
    context 'when missing' do
      let(:firm_telephone_number) { nil }

      it { is_expected.not_to be_valid }
    end

    context 'when invalid' do
      let(:firm_telephone_number) { 'invalid-telephone-number' }

      it { is_expected.not_to be_valid }
    end
  end
end
