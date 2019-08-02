class VerifyFrnJob < ActiveJob::Base
  include Sidekiq::Worker

  queue_as :default
  sidekiq_options retry: 5, backtrace: true, unique: :until_executed

  def perform(frn)
    @response = FcaApi::Request.new.get_firm(frn)

    if @response.ok?
      Rails.logger.info("FCA API successful request for #{frn}")
      firm_name
    else
      Rails.logger.warn("FCA API failed for #{frn}") 
      false
    end
  end

  private

  def firm_name
    @response.data['Organisation Name']
  end
end
