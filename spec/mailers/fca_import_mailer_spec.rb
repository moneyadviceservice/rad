RSpec.describe FcaImportMailer, type: :mailer do
  let(:recipient) { 'RADenquiries@moneyadviceservice.org.uk' }
  let(:subject_line) { 'Automated FCA Import Confirmation' }
  let(:users) { %w(user1@mas.org.uk user2@mas.org.uk) }
  let(:outcomes) do
    [
      ['advisers',     [], [], []],
      ['firms',        [], [], []],
      ['subsidiaries', [], [], []]
    ]
  end

  subject { FcaImportMailer.notify(users, outcomes) }

  specify { expect(subject.to).to match_array(users) }
  specify { expect(subject.subject).to eq(subject_line) }
  specify { expect(subject.body.encoded).to include('advisers') }
  specify { expect(subject.body.encoded).to include('firms') }
  specify { expect(subject.body.encoded).to include('subsidiaries') }
end
