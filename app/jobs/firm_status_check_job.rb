require './lib/fca_api/connection'
require './lib/fca_api/request'
require './lib/fca_api/response'

class FirmStatusCheckJob < ActiveJob::Base
  include Sidekiq::Worker

  ACTIVE_FIRM_STATUS_CODES = [
    'Authorised',
    'Registered',
    'EEA Authorised',
    'Appointed representative'
  ].freeze

  queue_as :default
  sidekiq_options unique: :until_executed, retry: 5

  def perform(fca_number)
    api_request = FcaApi::Request.new
    response = api_request.get_firm(fca_number)
    status = response.data.fetch('Status')

    if status.in? ACTIVE_FIRM_STATUS_CODES
      logger.info "Firm #{fca_number} is ACTIVE"
    else
      logger.info "Firm #{fca_number} is INACTIVE with status #{status}"
      firm = Firm.where(fca_number: fca_number).first!
      InactiveFirm.create(firm_id: firm.id, api_status: status)
    end
  end
end
