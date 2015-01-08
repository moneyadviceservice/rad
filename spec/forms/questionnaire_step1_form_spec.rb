RSpec.describe QuestionnaireStep1Form, '#valid?', type: :model do
  let(:firm_email_address) { 'info@finsmart.com' }
  let(:firm_telephone_number) { '0300 500 5000' }
  let(:main_office_line_1) { 'Holborn Centre' }
  let(:main_office_line_2) { '120 Holborn' }
  let(:main_office_town) { 'London' }
  let(:main_office_county) { 'London' }
  let(:main_office_postcode) { 'EC1N 2TD' }
  let(:accept_customers_from) { ['London'] }

  subject do
    described_class.new({
      firm_email_address: firm_email_address,
      firm_telephone_number: firm_telephone_number,
      main_office_line_1: main_office_line_1,
      main_office_line_2: main_office_line_2,
      main_office_town: main_office_town,
      main_office_county: main_office_county,
      main_office_postcode: main_office_postcode,
      accept_customers_from: accept_customers_from
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

  describe 'main office town' do
    context 'when missing' do
      let(:main_office_town) { nil }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'main office county' do
    context 'when missing' do
      let(:main_office_county) { nil }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'main office postcode' do
    context 'when missing' do
      let(:main_office_postcode) { nil }

      it { is_expected.not_to be_valid }
    end

    context 'when invalid' do
      let(:main_office_postcode) { 'invalid-postcode' }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'accept customers from' do
    context 'when missing' do
      let(:accept_customers_from) { nil }

      it { is_expected.not_to be_valid }
    end

    context 'when empty array' do
      let(:accept_customers_from) { [] }

      it { is_expected.not_to be_valid }
    end

    context 'when not one of the options' do
      let(:accept_customers_from) { ['not-in-the-list'] }

      it { is_expected.not_to be_valid }
    end
  end
end
