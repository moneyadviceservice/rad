require 'ostruct'

RSpec.describe NewPrincipalForm, type: :model do
  let(:lookup_firm) { FactoryBot.create(:lookup_firm) }
  let(:valid_params) do
    {
      fca_number: lookup_firm.fca_number,
      first_name: 'First',
      last_name: 'Last',
      job_title: 'Job',
      email: 'ex@ample.com',
      telephone_number: '0780000000',
      confirmed_disclaimer: '1',
      password: 'Password1!',
      password_confirmation: 'Password1!'
    }
  end

  context 'with valid params' do
    before do
      allow_any_instance_of(FcaApi::Request).to receive(:get_firm) { true }
    end

    subject { NewPrincipalForm.new(valid_params) }

    it { is_expected.to be_valid }

    describe '#user_params' do
      let(:user) { User.new(subject.user_params) }

      it 'returns valid user params' do
        expect(user).to be_valid
      end
    end

    describe '#principal_params' do
      let(:principal) { Principal.new(subject.principal_params) }

      it 'returns valid principal params' do
        expect(principal).to be_valid
      end
    end
  end

  context 'with invalid params' do
    let(:invalid_params) { valid_params.merge(email: '') }
    subject { NewPrincipalForm.new(invalid_params) }

    before do
      allow_any_instance_of(FcaApi::Request).to receive(:get_firm) { false }
    end

    it { is_expected.not_to be_valid }

    it 'returns some errors' do
      subject.validate
      expect(subject.errors).to be_present
    end

    it 'does not return errors on email address' do
      subject.validate
      expect(subject.errors[:email_address]).to be_empty
    end

    it 'does not return duplicate errors on email' do
      subject.validate
      expect(subject.errors[:email]).to eq subject.errors[:email].uniq
    end
  end
end
