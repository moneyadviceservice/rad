module InactiveFirms
  class CheckApproved
    ACTIVE_FIRM_STATUS_CODES = [
      'Appointed representative - introducer',
      'Appointed representative',
      'Authorised - applied to cancel',
      'Authorised - applied to change business type',
      'Authorised - applied to change legal status',
      'Authorised',
      'EEA Authorised',
      'Registered'
    ].freeze

    attr_accessor :valid, :failure, :fca_status

    alias valid? valid
    alias failure? failure

    def initialize
      self.valid = false

      self.failure = false
    end

    def call(fca_number)
      self.response = call_api(fca_number)

      check_approved

      self
    end

    private

    attr_accessor :response

    def call_api(fca_number)
      request.get_firm(fca_number)
    rescue StandardError
      failed_response
    end

    def get_firm(fca_number)
      request.get_firm(fca_number)
    end

    def check_approved
      if failed?
        self.failure = true
      elsif found?
        self.valid = approved?

        self.fca_status = status unless valid?
      else
        self.fca_status = 'Not Found'
      end
    end

    def failed?
      message =~ /Failure/i
    end

    def found?
      message =~ /Ok. Firm Found/i
    end

    def approved?
      ACTIVE_FIRM_STATUS_CODES.include?(status)
    end

    def message
      body['Message'] || body['Message'.to_sym]
    end

    def status
      (data = body['Data']) && data.first['Status']
    end

    def body
      response.raw_response.body
    end

    def request
      @request ||= FcaApi::Request.new
    end

    def failed_response
      FcaApi::Response.new(faraday_response)
    end

    def faraday_response
      # For consistency with FcaApi::Request which makes the key Message a symbol
      Faraday::Response.new(body: { 'Message': 'Failure' })
    end
  end
end
