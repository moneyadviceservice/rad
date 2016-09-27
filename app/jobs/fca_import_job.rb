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
    return logger.info('Ignoring this request as we already have a fca import in progress') if create_model_for(files).new_record?

    FCA::Import.call(files, context) do |outcomes|
      notify(outcomes)
    end
  end

  private

  def context
    {
      pg: db_connection,
      model: @import
    }
  end

  def create_model_for(files)
    @import ||= FcaImport.create(
      files:  files.join('|'),
      status: 'processing'
    )
  end

  def db_connection
    @conn ||= ActiveRecord::Base.connection_pool.checkout.raw_connection
  end

  def slack
    @slack ||= Slack::Web::Client.new
  end

  def default_url_options
    { host: FCA::Config.hostname }
  end

  def notify_slack(text)
    tries ||= 1
    slack.chat_postMessage(
      channel: FCA::Config.notify[:slack][:channel],
      as_user: true,
      text:    "<!here> #{text}"
    )
  rescue
    logger.error 'An error occured while trying to post msg'
    retry if (tries += 1) <= 3
  end

  def notify_email(text)
    FcaImportMailer.notify(
      FCA::Config.email_recipients,
      text
    ).deliver_later
  end

  def notification_text(outcomes)
    if import_successful?(outcomes)
      "The FCA data have been loaded into RAD. Visit #{admin_lookup_fca_import_index_url} to confirm that the data looks ok" # rubocop:disable all
    else
      erroneous = outcomes
                  .select { |(_, s, _)| s == false }
                  .map { |(f, _, o)| "Zip file #{f} caused error: #{o}" }
      erroneous.insert(0, 'Import has failed')
      erroneous.insert(-1, "You can cancel this import here #{admin_lookup_fca_import_index_url}")
      erroneous.join("\n")
    end
  end

  def notify(outcomes)
    text = notification_text(outcomes)
    logger.info("Notification msg: #{text}")
    notify_email(text)
    notify_slack(text)
  end
end
