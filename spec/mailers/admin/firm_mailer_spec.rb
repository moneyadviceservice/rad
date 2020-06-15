RSpec.describe Admin::FirmMailer, type: :mailer do
  let(:recipient)    { ENV['TAD_ADMIN_EMAIL'] }
  let(:subject_line) { 'Travel insurance directory rejected firm' }
  let(:firm_data) { { fca_number: '123123', first_name: 'Joshua', last_name: 'Slocum', email: 'email@test.dev' } }

  describe '#rejected_firm' do
    subject { Admin::FirmMailer.rejected_firm(firm_data) }

    specify { expect(subject.to).to include recipient }
    specify { expect(subject.subject).to eq(subject_line) }
    specify { expect(subject.body.encoded).to include(firm_data[:fca_number]) }
    specify { expect(subject.body.encoded).to include(firm_data[:first_name]) }
    specify { expect(subject.body.encoded).to include(firm_data[:last_name]) }
    specify { expect(subject.body.encoded).to include(firm_data[:email]) }
  end
end
