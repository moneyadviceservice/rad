class UpdateAlgoliaIndexJob < ActiveJob::Base
  include Sidekiq::Worker

  queue_as :default
  sidekiq_options retry: 25, backtrace: true, unique: :until_executed

  def perform(klass, id, firm_id = nil)
    AlgoliaIndex.handle_update(klass: klass, id: id, firm_id: firm_id)
  end
end
