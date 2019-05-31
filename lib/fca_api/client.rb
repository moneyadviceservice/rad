module FcaApi
  class Client
    FIRM_ENDPOINT = '/services/V0.1/Firm'.freeze
    SUCCESS_MESSAGE = 'ok'
      
    attr_reader :connection, :product_connection

    def initialize
      @connection = Connection.new(ENV.fetch('FCA_API_DOMAIN'))      
    end

    def get_firm(firm_id)
      connection.get(full_path(FIRM_ENDPOINT, firm_id))
    end

    def response_ok?(response_data)
      response_data['Message'].downcase.include?(SUCCESS_MESSAGE)
    end

    private

    def full_path(endpoint, id)
      "#{endpoint}/#{id}"
    end
  end
end
