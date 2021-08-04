class CreateInactiveFirmsJob < ApplicationJob
  # This job queries the status of Firms against the FCA Register API.
  #
  # The API has an official rate limit of 10 requests every 10 seconds, hence
  # the values set in the constants below. We throttle requests to the API by
  # running them at no more than 5 per sec.
  #
  SLEEP_TIME = 0.2
  BATCH_SIZE = 10

  queue_as :default
  sidekiq_options unique: :until_executed

  def perform
    InactiveFirm.transaction do
      delete_previous

      [Firm, TravelInsuranceFirm].each { |resource| run_for_resource(resource) }
    end
  end

  private

  def delete_previous
    InactiveFirm.delete_all
  end

  def run_for_resource(resource)
    find_records(resource).each do |records|
      run_for_records(records)

      big_sleep
    end
  end

  def run_for_records(records)
    records.each do |record|
      raise ActiveRecord::Rollback, error_message(record) unless add_inactive_firm_if_unapproved(record)

      little_sleep
    end
  end

  def find_records(resource)
    resource.where(parent_id: nil).order(:id).find_in_batches(batch_size: BATCH_SIZE)
  end

  def add_inactive_firm_if_unapproved(record)
    create_unapproved.call(record)
  end

  def create_unapproved
    InactiveFirms::CreateUnapproved.new
  end

  def little_sleep
    sleep(SLEEP_TIME)
  end

  def big_sleep
    sleep(SLEEP_TIME * 5)
  end

  def error_message(record)
    "CreateInactiveFirmsJob on #{record.class}: #{record.to_param}"
  end
end
