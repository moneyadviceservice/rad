RSpec.describe ContactForm, type: :model do
  let(:email) { 'principal@ifa.com' }
  let(:invalid_email) { 'principal@ifa..com' }
  let(:message) { 'my querysome query' }
  let(:params) { {} }

  subject { described_class.new(params) }

  describe '#field_order' do
    it { expect(subject.field_order).to eql(%i[email message]) }
  end

  context 'with an empty message' do
    let(:params) do
      {
        email: email,
        message: ''
      }
    end

    it { is_expected.to_not be_valid }
  end

  context 'with an invalid email address' do
    let(:params) do
      {
        email: invalid_email,
        message: message
      }
    end

    it { is_expected.to_not be_valid }
  end

  context 'with valid data' do
    let(:params) do
      {
        email: email,
        message: message
      }
    end

    it { is_expected.to be_valid }
  end
end
