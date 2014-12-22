RSpec.describe IdentificationEmailWorker do
  let(:principal) { FactoryGirl.create(:principal) }

  subject { described_class.new.perform(principal.id) }

  it 'delivers an email' do
    expect { subject }.to change { ActionMailer::Base.deliveries }
  end
end
