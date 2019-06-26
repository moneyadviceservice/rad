module FcaApi
  class Request
    FIRM_ENDPOINT = '/services/V0.1/Firm'.freeze

    attr_reader :connection, :product_connection

    def initialize
      @connection = Connection.new(ENV.fetch('FCA_API_DOMAIN'))
    end

    def get_firm(firm_id)
      response = connection.get(full_path(FIRM_ENDPOINT, firm_id))
      FcaApi::Response.new(response)
    end

    private

    def full_path(endpoint, id)
      "#{endpoint}/#{id}"
    end
  end
end
