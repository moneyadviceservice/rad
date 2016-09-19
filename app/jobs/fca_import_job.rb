require 'digest/sha1'
require 'slack-ruby-client'
$LOAD_PATH.unshift(File.join(Rails.root, 'lib'))
require 'fca'

class FcaImportJob < ActiveJob::Base
  include FCA::Utils
  include Rails.application.routes.url_helpers
  include Sidekiq::Worker
  sidekiq_options unique:      :until_executed,
                  unique_args: ->(args) { Digest::SHA1.hexdigest(args.first.to_s) }
  queue_as :default

  def perform(files = [])
    FCA::Import.call(files, db_connection) do |outcomes|
      slack.chat_postMessage(slack_formatter(outcomes))
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

  def slack
    @slack ||= Slack::Web::Client.new
  end

  def slack_formatter(outcomes)
    import_successful?(outcomes) ? confirm : error
  end

  def confirm
    url = admin_lookup_fca_import_index_url
    {
      channel: FCA::Config.notify[:slack][:channel],
      as_user: true,
      text:    "The FCA data have been loaded into RAD. Visit #{url} to confirm that the data looks ok"
    }
  end

  def error
    {
      channel: FCA::Config.notify[:slack][:channel],
      as_user: true,
      text:    'An error has occured while processing the files'
    }
  end

  def default_url_options
    { host: FCA::Config.hostname }
  end
end
