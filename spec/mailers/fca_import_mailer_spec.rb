RSpec.describe FcaImportMailer, type: :mailer do
  let(:recipient)    { 'RADenquiries@moneyhelper.org.uk' }
  let(:subject_line) { 'Automated FCA Import Notification' }
  let(:users)        { %w[user1@mas.org.uk user2@mas.org.uk] }
  let(:text)         { 'Some text ...' }

  subject { FcaImportMailer.notify(users, text) }

  specify { expect(subject.to).to match_array(users) }
  specify { expect(subject.subject).to eq(subject_line) }
  specify { expect(subject.body.encoded).to include(text) }
end
