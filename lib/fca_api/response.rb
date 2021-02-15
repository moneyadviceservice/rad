module FcaApi
  class Response
    SUCCESS_MESSAGE = 'ok'.freeze

    attr_reader :raw_response

    def initialize(raw_response)
      @raw_response = raw_response
    end

    def ok?
      return false if raw_response.body['Message'].nil?

      raw_response.body['Message'].downcase.include?(SUCCESS_MESSAGE)
    end

    def data
      raw_response.body['Data'].first
    end
  end
end
