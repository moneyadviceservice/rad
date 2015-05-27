module Dashboard
  module DashboardHelper
    def firm_count
      @trading_names.count + (@firm.present? ? 1 : 0)
    end
  end
end
