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
    ext_to_sql = ::ExtToSql.new(zip_file_content)
    raw_connection.exec ext_to_sql.prefix_sql

    ext_to_sql.process_ext_file_content do |line|
      raw_connection.put_copy_data(line + "\n")
    end
  rescue StandardError => e
    ruby_exception_message = e.message + ' ' + e.backtrace.join
  ensure
    postgres_exception_message = clean_up_connection raw_connection

    fail(ruby_exception_message) if ruby_exception_message.present?
    fail(postgres_exception_message) if postgres_exception_message.present?
  end

  def clean_up_connection(raw_connection)
    raw_connection.put_copy_end
    res = raw_connection.get_result

    res.error_message.present? ? ('Error applying generated SQL: ' + res.error_message) : nil
  end
end
