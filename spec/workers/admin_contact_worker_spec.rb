RSpec.describe AdminContactWorker, '#perform' do
  let(:email) { 'principal@ifa.com' }
  let(:message) { 'my querysome query' }
  let(:mailer) { double }

  subject(:perform_job) { described_class.new.perform(email, message) }

  before do
    allow(AdminContact).to receive(:contact).with(email, message).and_return(mailer)
  end

  it 'delivers the email' do
    expect(mailer).to receive(:deliver_now)
    perform_job
  end
end
