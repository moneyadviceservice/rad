RSpec.describe UploadFcaDataJob, type: :job do
  include ActiveJob::TestHelper

  it 'is a Sidekiq worker' do
    expect(described_class.new).to be_a(Sidekiq::Worker)
  end

  describe '#perform' do
    let(:fixture_content) do
      File.open(File.expand_path("spec/fixtures/#{fixture_name}.ext"), 'rb').read
    end

    let(:email_recipient) { 'someone@mas.org.uk' }
    let(:zip_file) { 'date_c.zip' }

    subject { described_class.new }

    context 'imports advisers file' do
      let(:fixture_name) { 'advisers' }

      it 'creates the advisers in the db' do
        subject.perform fixture_content, email_recipient, zip_file
        expect(Lookup::Import::Adviser.count).to eql(2)
      end

      it 'sends success email' do
        perform_enqueued_jobs do
          subject.perform fixture_content, email_recipient, zip_file
          delivered_email = ActionMailer::Base.deliveries.last
          expect(delivered_email.subject).to eql('FCA file uploaded successfully')
          expect(delivered_email.to).to include(email_recipient)
          expect(delivered_email.body).to include(zip_file)
        end
      end
    end

    context 'broken data' do
      let(:fixture_name) { 'advisers_with_bad_row' }

      it 'fails' do
        allow_any_instance_of(PG::Result).to receive(:error_message).and_return('issue uploading adviser file')
        expected_message = 'Error uploading: issue uploading adviser file'
        expect { subject.perform(fixture_content, email_recipient, zip_file) }.to raise_exception(expected_message)
      end

      it 'sends failure email' do
        allow_any_instance_of(PG::Result).to receive(:error_message).and_return('issue uploading adviser file')
        perform_enqueued_jobs do
          expect { subject.perform fixture_content, email_recipient, zip_file }.to raise_exception

          delivered_email = ActionMailer::Base.deliveries.last
          expect(delivered_email.subject).to eql('FCA file upload failed')
          expect(delivered_email.to).to include(email_recipient)
          expect(delivered_email.body).to include(zip_file)
          expect(delivered_email.body).to include('issue uploading adviser file')
        end
      end

      it 'sends failure email' do
        allow_any_instance_of(ExtToSql).to receive(:process_ext_file_content).and_raise('exception raised by our code')
        perform_enqueued_jobs do
          expect { subject.perform fixture_content, email_recipient, zip_file }.to raise_exception

          delivered_email = ActionMailer::Base.deliveries.last
          expect(delivered_email.subject).to eql('FCA file upload failed')
          expect(delivered_email.to).to include(email_recipient)
          expect(delivered_email.body).to include(zip_file)
          expect(delivered_email.body).to include('exception raised by our code')
        end
      end
    end
  end
end
