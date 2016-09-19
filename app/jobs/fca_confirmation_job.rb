require 'digest/sha1'
$LOAD_PATH.unshift(File.join(Rails.root, 'lib'))
require 'cloud'
require 'fca'

class FcaConfirmationJob < ActiveJob::Base
  include Sidekiq::Worker
  sidekiq_options unique:      :until_executed,
                  unique_args: ->(args) { Digest::SHA1.hexdigest(args.first.to_s) }
  queue_as :default

  def perform(import_job_id)
    if import = FcaImport.find_by_id(import_job_id) # rubocop:disable all
      rename('fcaimport')
      import.update_attributes(status: 'confirmed')
      log 'Postgres', 'Import confirmed'
      archive_files(import.files.split('|'))
    end
  end

  private

  def archive_files(files)
    cs = Cloud::Storage.client
    files.each { |f| cs.move(f, f.gsub('incoming', 'archives')) }
    log 'Azure', "Archived files: #{files}"
  end

  def rename(prefix)
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
