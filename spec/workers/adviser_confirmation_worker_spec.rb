RSpec.describe AdviserConfirmationWorker, '#perform', type: :model do
  let(:email) { 'gimme@yourmoney.com' }
  let(:adviser) { Adviser.where(email: email).first }

  before do
    ActionMailer::Base.deliveries.clear
    described_class.new.perform(email)
  end

  specify { expect(adviser).to_not be_confirmed }
  specify { expect(ActionMailer::Base.deliveries.count).to eq(1) }

  it 'sends a confirmation token' do
    expect(ActionMailer::Base.deliveries.first.body).to include('confirmation_token')
  end
end
