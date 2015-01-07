RSpec.describe QuestionnaireStep1Form, '#valid?', type: :model do
  let(:firm_email_address) { 'info@finsmart.com' }
  let(:firm_telephone_number) { '0300 500 5000' }
  let(:main_office_line_1) { 'Holborn Centre' }
  let(:main_office_line_2) { '120 Holborn' }

  subject do
    described_class.new({
      firm_email_address: firm_email_address,
      firm_telephone_number: firm_telephone_number,
      main_office_line_1: main_office_line_1,
      main_office_line_2: main_office_line_2
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

  describe 'main office line 1' do
    context 'when missing' do
      let(:main_office_line_1) { nil }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'main office line 2' do
    context 'when missing' do
      let(:main_office_line_2) { nil }

      it { is_expected.not_to be_valid }
    end
  end
end
