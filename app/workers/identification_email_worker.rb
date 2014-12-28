class IdentificationEmailWorker
  include Sidekiq::Worker

  def perform(id)
    principal = Principal.find(id)
    Identification.contact(principal).deliver_now
  end
end
