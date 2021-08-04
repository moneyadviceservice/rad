module InactiveFirms
  class CreateUnapproved
    def call(firm)
      get_response(firm)

      if response.failure?
        false
      elsif response.valid?
        true
      else
        create_inactive_firm(firm, response.fca_status)
      end
    end

    private

    attr_accessor :response

    def get_response(firm)
      self.response = check_approved.call(firm.fca_number)
    end

    def check_approved
      @check_approved ||= CheckApproved.new
    end

    def create_inactive_firm(firm, status)
      InactiveFirm.create(firmable: firm, api_status: status)
    end
  end
end
