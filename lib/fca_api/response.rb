module FcaApi
  class Response
    SUCCESS_MESSAGE = 'ok'
      
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def ok?
      response.body['Message'].downcase.include?(SUCCESS_MESSAGE)
    end
  end
end
