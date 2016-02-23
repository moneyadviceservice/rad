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
      icon_toggle @firm.publishable?
    end

    def firm_details_icon
      icon_toggle @firm.registered?
    end

    def advisers_icon
      icon_toggle @firm.advisers.any?
    end

    def offices_icon
      icon_toggle @firm.offices.any?
    end

    def firm_details_link(opts = {})
      if @firm.trading_name?
        link_to 'Edit', edit_self_service_trading_name_path(@firm), opts
      else
        link_to 'Edit', edit_self_service_firm_path(@firm), opts
      end
    end

    def advisers_link(opts = {})
      if @firm.advisers.present?
        link_to 'Manage', self_service_firm_advisers_path(@firm), opts
      else
        link_to 'Add', new_self_service_firm_adviser_path(@firm), opts
      end
    end

    def offices_link(opts = {})
      if @firm.offices.present?
        link_to 'Manage', self_service_firm_offices_path(@firm), opts
      else
        link_to 'Add', new_self_service_firm_office_path(@firm), opts
      end
    end

    private

    def icon_toggle(condition_met)
      condition_met ? 'tick' : 'exclamation'
    end
  end
end
