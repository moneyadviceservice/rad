module SelfService
  class StatusPresenter
    include Rails.application.routes.url_helpers
    include ActionView::Helpers::UrlHelper

    def initialize(firm)
      @firm = firm
    end

    def overall_status
      @firm.publishable? ? 'published' : 'unpublished'
    end

    def overall_status_icon
      @firm.publishable? ? 'tick' : 'exclamation'
    end

    def firm_details_icon
      @firm.registered? ? 'tick' : 'exclamation'
    end

    def firm_details_link(opts = {})
      link_to 'Edit', firm_details_link_path, opts
    end

    private

    def firm_details_link_path
      route = @firm.trading_name? ? 'trading_name' : 'firm'
      send "edit_self_service_#{route}_path", @firm
    end
  end
end
