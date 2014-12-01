class AdviserConfirmationWorker
  include Sidekiq::Worker

  def perform(email)
    Adviser.create(email: email)
  end
end
