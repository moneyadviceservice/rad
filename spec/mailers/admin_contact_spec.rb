RSpec.describe AdminContact, '#contact' do
  let(:recipient) { 'IFADirectoryQueries@moneyadviceservice.org.uk' }
  let(:subject_line) { 'IFA Contact' }
  let(:message) { 'my querysome query' }

  subject { described_class.contact(message) }

  specify { expect(subject.to.first).to eq(recipient) }
  specify { expect(subject.subject).to eq(subject_line) }
  specify { expect(subject.body.encoded).to include(message) }
end
