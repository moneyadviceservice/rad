require 'digest/sha1'
$LOAD_PATH.unshift(Rails.root.join('lib'))
require 'cloud'
require 'fca'

class FcaConfirmationJob < ActiveJob::Base
  include Sidekiq::Worker

  unique_args = ->(args) { Digest::SHA1.hexdigest(args.first.to_s) }
  sidekiq_options unique:      :until_executed,
                  unique_args: unique_args
  queue_as :default

  def perform(import_job_id)
    import = FcaImport.find_by(id: import_job_id)
    return unless import

    rename_tables(::FCA::Import::LOOKUP_TABLE_PREFIX)

    # rubocop:disable Rails/SkipsModelValidations
    import.update_column(:status, 'confirmed')
    # rubocop:enable Rails/SkipsModelValidations

    log "FcaImport {#{import_job_id}}", 'Import confirmed'
    archive_files(import.files.split('|'))
  end

  private

  def archive_files(files)
    cs = Cloud::Storage.client
    files.each { |f| cs.move(f, f.gsub(/incoming/i, 'archives')) }
    log 'Azure', "Archived files: #{files}"
  end

  def rename_tables(prefix)
    sql = FCA::Query
          .all
          .map { |t| FCA::Query.new(table: t, prefix: prefix).rename }
          .join("\n")

    ActiveRecord::Base.connection.execute(sql)
    log 'Postgres', 'Import applied :)'
  end

  def log(name, msg)
    FCA::Config.logger.info(name) { msg }
  end
end
