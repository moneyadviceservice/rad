class EnqueueFirmStatusChecksJob < ApplicationJob
  # This job schedules the work carried out by FirmStatusCheckJob, which
  # queries the status of Firms against the FCA Register API.
  #
  # The API has an official rate limit of 10 requests every 10 seconds, hence
  # the values set in the constants below. We throttle requests to the API by
  # scheduling each batch of 10 status checks to occur at the beginning of a
  # 10-second window. The 10 checks occur concurrently and windows are
  # sequential.
  #
  # The other value relevant to this functionality is the scheduled job poll
  # interval set in the sidekiq server configuration. This controls how often
  # Sidekiq checks for scheduled jobs. That value is ~15 seconds by defauilt -
  # this job has been tested at that level of polling and holds up well across
  # large numbers of firms without triggering the rate limit. Changes to that
  # value should be tested, but in theory any value between 10 and 20 seconds
  # should be ok. This is because in practice the API rate limit appears to be
  # higher than the official numbers. Up to 20 requests per 10 seconds have
  # been tested without issue. With a schedule poll of 15 seconds, 10 to 20
  # jobs should execute each time (as certain times will pick up two windows
  # worth of jobs rather than just one, eg - the 30-second mark).
  WINDOW_LENGTH_IN_SECONDS = 10
  BATCH_SIZE = 10

  queue_as :default
  sidekiq_options unique: :until_executed

  # Fetch firms from the database table in batches. Each batch has its own time
  # window of length WINDOW_LENGTH_IN_SECONDS. Within this window, enqueue one
  # job per firm to check the status.
  def perform(batches: BigDecimal::INFINITY)
    time_window = 0
    InactiveFirm.destroy_all

    Firm
      .find_in_batches(batch_size: BATCH_SIZE)
      .with_index do |group, batch_number|
      break if batch_number == batches

      group.each do |firm|
        current_time = Time.now.to_f

        FirmStatusCheckJob.perform_at(
          current_time + time_window.seconds,
          firm.fca_number
        )
      end
      time_window += WINDOW_LENGTH_IN_SECONDS
    end
  end
end
