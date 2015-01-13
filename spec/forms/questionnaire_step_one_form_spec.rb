RSpec.describe QuestionnaireStepOneForm, '#valid?', type: :model do
  let(:email_address) { 'info@finsmart.com' }
  let(:telephone_number) { '0300 500 5000' }
  let(:address_line_1) { 'Holborn Centre' }
  let(:address_line_2) { '120 Holborn' }
  let(:address_town) { 'London' }
  let(:address_county) { 'London' }
  let(:address_postcode) { 'EC1N 2TD' }
  let(:accept_customers_from) { ['London'] }
  let(:in_person_advice) { ['At an agreed location'] }
  let(:other_methods_of_advice) { ['Advice by telephone through to transaction'] }
  let(:initial_meeting) { true }
  let(:initial_meeting_duration) { '30 min' }
  let(:initial_advice_fee) { 'Hourly fee' }
  let(:ongoing_advice_fee) { 'Monthly by direct debit' }
  let(:payment_methods) { 'From funds to be invested' }
  let(:minimum_fixed_fee) { '£2,300.00' }

  subject do
    described_class.new({
      email_address: email_address,
      telephone_number: telephone_number,
      address_line_1: address_line_1,
      address_line_2: address_line_2,
      address_town: address_town,
      address_county: address_county,
      address_postcode: address_postcode,
      accept_customers_from: accept_customers_from,
      in_person_advice: in_person_advice,
      other_methods_of_advice: other_methods_of_advice,
      initial_meeting: initial_meeting,
      initial_meeting_duration: initial_meeting_duration,
      initial_advice_fee: initial_advice_fee,
      ongoing_advice_fee: ongoing_advice_fee,
      payment_methods: payment_methods,
      minimum_fixed_fee: minimum_fixed_fee
    })
  end

  context 'with valid params' do
    it { is_expected.to be_valid }
  end

  describe 'email address' do
    context 'when missing' do
      let(:email_address) { nil }

      it { is_expected.not_to be_valid }
    end

    context 'when invalid' do
      let(:email_address) { 'invalid-email-format' }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'telephone number' do
    context 'when missing' do
      let(:telephone_number) { nil }

      it { is_expected.not_to be_valid }
    end

    context 'when invalid' do
      let(:telephone_number) { 'invalid-telephone-number' }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'address line 1' do
    context 'when missing' do
      let(:address_line_1) { nil }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'address line 2' do
    context 'when missing' do
      let(:address_line_2) { nil }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'address town' do
    context 'when missing' do
      let(:address_town) { nil }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'address county' do
    context 'when missing' do
      let(:address_county) { nil }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'address postcode' do
    context 'when missing' do
      let(:address_postcode) { nil }

      it { is_expected.not_to be_valid }
    end

    context 'when invalid' do
      let(:address_postcode) { 'invalid-postcode' }

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

  describe 'in person advice' do
    context 'when missing' do
      let(:in_person_advice) { nil }

      it { is_expected.not_to be_valid }
    end

    context 'when empty array' do
      let(:in_person_advice) { [] }

      it { is_expected.not_to be_valid }
    end

    context 'when not one of the options' do
      let(:in_person_advice) { ['not-in-the-list'] }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'other methods of advice' do
    context 'when not one of the options' do
      let(:other_methods_of_advice) { ['not-in-the-list'] }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'initial meeting' do
    context 'when missing' do
      let(:initial_meeting) { nil }

      it { is_expected.not_to be_valid }
    end

    context 'when not one of the options' do
      let(:initial_meeting) { ['not-in-the-list'] }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'initial meeting duration' do
    context 'when missing' do
      let(:initial_meeting_duration) { nil }

      it { is_expected.to be_valid }
    end

    context 'when not one of the options' do
      let(:initial_meeting_duration) { ['not-in-the-list'] }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'initial advice fee' do
    context 'when missing' do
      let(:initial_advice_fee) { nil }

      it { is_expected.not_to be_valid }
    end

    context 'when not one of the options' do
      let(:initial_advice_fee) { ['not-in-the-list'] }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'ongoing advice fee' do
    context 'when missing' do
      let(:ongoing_advice_fee) { nil }

      it { is_expected.not_to be_valid }
    end

    context 'when not one of the options' do
      let(:ongoing_advice_fee) { ['not-in-the-list'] }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'payment methods' do
    context 'when missing' do
      let(:payment_methods) { nil }

      it { is_expected.not_to be_valid }
    end

    context 'when not one of the options' do
      let(:payment_methods) { ['not-in-the-list'] }

      it { is_expected.not_to be_valid }
    end
  end
end
