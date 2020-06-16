RSpec.describe NewFirmMailer, type: :mailer do
  let(:recipient)    { ENV['TAD_ADMIN_EMAIL'] }
  let(:subject_line) { 'New Firm registered in the directory' }

  shared_examples_for 'new firm notification mailer' do
    describe '#notify' do
      subject { NewFirmMailer.notify(firm) }

      specify { expect(subject.to).to eq email_recipient }
      specify { expect(subject.subject).to eq(subject_line) }
      specify { expect(subject.body.encoded).to include(firm.registered_name) }
    end
  end

  describe 'retirement advice firm' do
    let!(:firm) { create(:firm_with_principal, registered_name: 'OrgName') }
    let(:email_recipient) { FCA::Config.email_recipients }
    it_behaves_like 'new firm notification mailer'
  end

  describe 'travel insurance firm' do
    let!(:firm) { create(:travel_insurance_firm, registered_name: 'TavelInsurance', create_associated_principle: true) }
    let(:email_recipient) { [ENV['TAD_ADMIN_EMAIL']] }
    it_behaves_like 'new firm notification mailer'
  end
end
