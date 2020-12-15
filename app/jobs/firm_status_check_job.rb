require './lib/fca_api/connection'
require './lib/fca_api/request'
require './lib/fca_api/response'

class FirmStatusCheckJob < ApplicationJob
  ACTIVE_FIRM_STATUS_CODES = [
    'Appointed representative - introducer',
    'Appointed representative',
    'Authorised - applied to cancel',
    'Authorised - applied to change business type',
    'Authorised - applied to change legal status',
    'Authorised',
    'EEA Authorised',
    'Registered',
  ].freeze

  queue_as :default
  sidekiq_options unique: :until_executed, retry: 5

  def perform(firm)
    response = FcaApi::Request.new.get_firm(firm.fca_number)

    if response.ok?
      status = response.data.fetch('Status')
    else
      logger.info "Firm #{firm.fca_number} is not in FCA API"
      status = 'Not Found'
    end

    if status.in? ACTIVE_FIRM_STATUS_CODES
      logger.info "Firm #{firm.fca_number} is ACTIVE"
    else
      logger.info "Firm #{firm.fca_number} is INACTIVE with status #{status}"

      InactiveFirm.create(firmable: firm, api_status: status)
    end
  end
end
