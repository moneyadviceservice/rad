class AdminContactWorker
  include Sidekiq::Worker

  def perform(email, message)
    AdminContact.contact(email, message).deliver_now
  end
end
