require 'digest/sha1'
$LOAD_PATH.unshift(File.join(Rails.root, 'lib'))
require 'fca'

class FcaImportJob < ActiveJob::Base
  include Sidekiq::Worker
  sidekiq_options unique:      :until_executed,
                  unique_args: ->(args) { Digest::SHA1.hexdigest(args.first.to_s) }
  queue_as :default

  def perform(files = [], emails = [])
    FCA::Import.call(files, db_connection) do |outcomes|
      FcaImportMailer.notify(emails, outcomes).deliver_now
    end
  end

  private

  def db_connection
    return @conn if @conn
    db_conf = ActiveRecord::Base.connection_config
    config = {
      host:     db_conf[:host],
      port:     (db_conf[:port] || 5432),
      dbname:   db_conf[:database],
      user:     db_conf[:username],
      password: db_conf[:password],
      connect_timeout: 5
    }
    @conn ||= PG::Connection.new(config)
  end
end
