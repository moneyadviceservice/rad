require 'digest/sha1'
$:.unshift(File.join(Rails.root, 'lib'))
require 'fca'

class FcaImportJob < ActiveJob::Base
  include Sidekiq::Worker
  sidekiq_options unique:      :until_executed,
                  unique_args: ->(args) { Digest::SHA1.hexdigest(args.first.to_s) }
  queue_as :default

  def perform(files = [], emails = [])
    FCA::Import.call(files) do |outcomes, log|
      FcaImportMailer.notify(emails, outcomes).deliver_now
    end
  end
end
