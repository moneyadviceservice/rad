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
    let(:fixture_name) { 'advisers' }

    subject { described_class.new }

    context 'imports advisers file' do
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

    context 'exception handling' do
      it 'fails when there is an error applying sql to db' do
        allow_any_instance_of(PG::Result).to receive(:error_message).and_return('issue uploading adviser file')
        expected_message = 'Error applying generated SQL: issue uploading adviser file'
        expect { subject.perform(fixture_content, email_recipient, zip_file) }.to raise_exception(expected_message)
      end

      it 'fails when generating sql' do
        allow_any_instance_of(ExtToSql).to receive(:process_ext_file_content).and_raise('Exception raised by our code')
        expect do
          subject.perform(fixture_content, email_recipient, zip_file)
        end.to raise_error(/^Exception raised by our code/)
      end

      it 'reports exception generating sql when generating sql and db throw exceptions' do
        allow_any_instance_of(ExtToSql).to receive(:process_ext_file_content).and_raise('Exception raised by our code')
        allow_any_instance_of(PG::Result).to receive(:error_message).and_return('Execption raised by postgres')

        expect do
          subject.perform(fixture_content, email_recipient, zip_file)
        end.to raise_error(/^Exception raised by our code/)
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
