module FcaApi
  class Request
    FIRM_ENDPOINT = '/services/V0.1/Firm'.freeze
    INDIVIDUAL_ENDPOINT = '/services/V0.1/Individuals'.freeze

    attr_reader :connection, :product_connection

    def initialize
      @connection = Connection.new(ENV.fetch('FCA_API_DOMAIN'))
    end

    def get_firm(firm_id)
      begin
        response = connection.get(full_path(FIRM_ENDPOINT, firm_id))
      rescue Faraday::ParsingError
        response = Faraday::Response.new(body: { 'Message': 'Failure' })
      end

      FcaApi::Response.new(response)
    end

    def get_individual(reference)
      begin
        response = connection.get("#{INDIVIDUAL_ENDPOINT}/#{reference}")
      rescue Faraday::ClientError
        response = Faraday::Response.new(body: { 'Message': 'Failure' })
      end

      FcaApi::Response.new(response)
    end

    private

    def full_path(endpoint, id)
      "#{endpoint}/#{id}"
    end
  end
end
