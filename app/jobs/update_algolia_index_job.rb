class UpdateAlgoliaIndexJob < ActiveJob::Base
  include Sidekiq::Worker

  queue_as :default
  sidekiq_options retry: 15, backtrace: true

  def perform(klass, id)
    AlgoliaIndex.handle_update!(klass: klass, id: id)
  end
end
