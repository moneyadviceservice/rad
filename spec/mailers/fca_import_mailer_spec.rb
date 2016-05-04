RSpec.describe FcaImportMailer, type: :mailer do
  describe '#successful_upload' do
    let(:from) { 'RADenquiries@moneyadviceservice.org.uk' }
    let(:subject_line) { 'FCA file uploaded successfully' }
    let(:email) { 'test@email.com' }
    let(:filename) { 'date_c.zip' }

    subject { described_class.successful_upload(email, filename) }

    specify { expect(subject.to.first).to eq(email) }
    specify { expect(subject.from.first).to eq(from) }
    specify { expect(subject.subject).to eq(subject_line) }
    specify { expect(subject.body.encoded).to include(filename) }
  end
end
