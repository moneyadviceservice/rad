RSpec.describe ContactsController, '#create', type: :controller do
  let(:email) { 'principal@ifa.com' }
  let(:message) { 'my querysome query' }

  subject { response.code }

  context 'with valid params' do
    before do
      expect(AdminContactWorker).to receive(:perform_async).with(email, message)
      post :create, contact: { email: email, message: message }
    end

    it { is_expected.to eq('200') }
  end

  context 'with invalid params' do
    before do
      expect(AdminContactWorker).to_not receive(:perform_async)
      post :create
    end

    it { is_expected.to eq('400') }
  end
end
