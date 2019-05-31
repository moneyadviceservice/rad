module FCA_API

  class Connection
    attr_reader :domain, :raw_connection, :timeout, :retries, :api_email, :api_key
    delegate :headers, :post, to: :raw_connection

    def initialize(domain)
      @domain = domain
      @api_email = ENV.fetch('FCA_API_EMAIL')
      @api_key = ENV.fetch('FCA_API_KEY')
      @retries = ENV.fetch('FCA_API_MAX_RETRIES').to_i
      @timeout = ENV.fetch('FCA_API_TIMEOUT').to_i
      configure_raw_connection
    end

    def configure_raw_connection
      @raw_connection = Faraday.new(
        domain,
        request: { timeout: timeout },
        headers: request_headers
      ) do |connection|
        connection.request :json
        connection.request :retry, **retry_settings
        connection.response :raise_error
        connection.response(:json, parser_options: { quirks_mode: true })
        connection.response(
          :logger, Rails.logger, headers: false, bodies: false
        )
        connection.use :instrumentation
        connection.adapter Faraday.default_adapter
      end
    end

    def get(path)
      raw_connection.get(path)
    end

    private

    def request_headers
      {
        'X-Auth-Email' => api_email,
        'X-Auth_Key' => api_key
      }
    end

    def retry_settings
      {
        max: retries,
        interval: 1,
        backoff_factor: 2
      }
    end
  end
end
