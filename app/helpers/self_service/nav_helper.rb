module SelfService
  module NavHelper
    def self_service_firm_details_url(firm)
      return edit_self_service_trading_name_path(firm) if firm.trading_name?

      edit_self_service_firm_path(firm)
    end
  end
end
