class UploadFcaDataJob < ActiveJob::Base
  include Sidekiq::Worker

  queue_as :default

  def perform(zip_file_content, email_recipient, zip_filename)
    upload_data(zip_file_content)
    ::FcaImportMailer.successful_upload(email_recipient, zip_filename).deliver_later
  rescue StandardError => e
    ::FcaImportMailer.failed_upload(email_recipient, zip_filename, e.message).deliver_later
    raise e
  end

  private

  def upload_data(zip_file_content)
    raw_connection = ActiveRecord::Base.connection.raw_connection
    ext_to_sql = ::ExtToSql.new(zip_file_content, STDERR)
    raw_connection.exec ext_to_sql.truncate_and_copy_sql

    ext_to_sql.process_ext_file_content do |line|
      raw_connection.put_copy_data(line + "\n")
    end
  ensure
    raw_connection.put_copy_end
    res = raw_connection.get_result

    fail('Error uploading: ' + res.error_message) if res.error_message.present?
  end
end
