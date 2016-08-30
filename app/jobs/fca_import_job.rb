class FcaImportJob < ActiveJob::Base
  include Sidekiq::Worker

  queue_as :default

  def perform(_files_to_process)
  end
end
