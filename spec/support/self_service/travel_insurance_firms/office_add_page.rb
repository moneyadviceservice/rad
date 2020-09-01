require_relative 'office_edit_page'

module SelfService
  module TravelInsuranceFirms
    class OfficeAddPage < OfficeEditPage
      set_url '/self_service/travel_insurance_firms/{firm}/offices/new'
      set_url_matcher %r{/self_service/travel_insurance_firms/\d+/offices/new}
    end
  end
end
