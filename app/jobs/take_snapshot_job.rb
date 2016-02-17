class TakeSnapshotJob < ActiveJob::Base
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  queue_as :default

  def perform(*)
    Snapshot.new.run_queries_and_save
  end
end
