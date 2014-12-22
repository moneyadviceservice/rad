RSpec.describe IdentificationEmailWorker do
  let(:principal) { Principal.create!(email_address: 'ben@example.com') }

  subject { described_class.new.perform(principal.id) }

  it 'delivers an email' do
    expect { subject }.to change { ActionMailer::Base.deliveries }
  end
end
