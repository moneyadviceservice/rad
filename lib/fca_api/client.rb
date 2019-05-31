module FCA_API
  class Client
    FIRM_ENDPOINT = '/services/V0.1/Firm'.freeze
      
    attr_reader :connection, :product_connection

    def initialize
      @connection = Connection.new(ENV.fetch('FCA_API_DOMAIN'))      
    end

    def firm(firm_id)
      response = connection.get(full_path(FIRM_ENDPOINT, firm_id)).body
    end

    private

    def full_path(endpoint, id)
      "#{endpoint}/#{id}"
    end
  end
end
