RSpec.describe AdminContact, '#contact' do
  let(:recipient) { 'RADenquiries@moneyhelper.org.uk' }
  let(:subject_line) { 'IFA Contact' }
  let(:email) { 'principal@ifa.com' }
  let(:message) { 'my querysome query' }

  subject { described_class.contact(email, message) }

  specify { expect(subject.to.first).to eq(recipient) }
  specify { expect(subject.subject).to eq(subject_line) }
  specify { expect(subject.body.encoded).to include(email) }
  specify { expect(subject.body.encoded).to include(message) }
end
