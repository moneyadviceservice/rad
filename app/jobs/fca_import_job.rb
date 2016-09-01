require 'digest/sha1'

class FcaImportJob < ActiveJob::Base
  include Sidekiq::Worker
  sidekiq_options unique:      :until_executed,
                  unique_args: ->(args) { Digest::SHA1.hexdigest(args.first.to_s) }
  queue_as :default

  def perform(files, users)
    FCA::Import.call(files) { |outcome, log| MAS::Notify.call(users, outcome, log) }
  end
end
