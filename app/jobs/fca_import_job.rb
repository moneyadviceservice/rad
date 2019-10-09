require 'digest/sha1'
$LOAD_PATH.unshift(Rails.root.join('lib'))
require 'fca'

class FcaImportJob < ActiveJob::Base
  include FCA::Utils
  include Rails.application.routes.url_helpers
  include Sidekiq::Worker

  unique_args = ->(args) { Digest::SHA1.hexdigest(args.first.to_s) }
  sidekiq_options unique:      :until_executed,
                  unique_args: unique_args
  queue_as :default

  def perform(files = [])
    if create_model_for(files).new_record?
      return logger.info(
        'Ignoring this request as we already have a fca import in progress'
      )
    end

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

  def default_url_options
    { host: FCA::Config.hostname }
  end

  def notify_email(text)
    FcaImportMailer.notify(
      FCA::Config.email_recipients,
      text
    ).deliver_later
  end

  def parse_error(list)
    if list.second.try(:success?)
      'could not be unzipped. The file could be corrupted.'
    else
      'technical error. Contact dev team at ' \
        'development.team@moneyadviceservice.org.uk'
    end
  end

  def notification_text(outcomes)
    if import_successful?(outcomes)
      'The FCA data have been loaded into RAD. Visit ' \
        "#{admin_lookup_fca_import_index_url} to confirm that the data looks ok"
    else
      erroneous = ['Import has failed']
      erroneous += outcomes
                   .select { |(_, s, _)| s == false }
                   .map do |(f, _, o)|
                     "Zip file #{f} caused error: #{parse_error(o)}"
                   end
      erroneous.push(
        "You can cancel this import here #{admin_lookup_fca_import_index_url}"
      )
      erroneous.join("\n")
    end
  end

  def notify(outcomes)
    text = notification_text(outcomes)
    logger.info("Notification msg: #{text}")
    notify_email(text)
  end
end
