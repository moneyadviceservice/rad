class VerifyFrnJob < ActiveJob::Base
  include Sidekiq::Worker

  queue_as :default
  sidekiq_options retry: 5, backtrace: true, unique: :until_executed

  def perform(form)
    FcaApi::Request.new.get_firm(form.fca_number).ok? ? true : false
  end
end
