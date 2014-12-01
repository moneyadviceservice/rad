class FirmConfirmationWorker
  include Sidekiq::Worker

  def perform(email)
    Firm.create(email: email)
  end
end
