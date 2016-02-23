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
      icon_toggle(remote? || @firm.advisers.any?)
    end

    def offices_icon
      icon_toggle @firm.offices.any?
    end

    def firm_details_link(opts = {})
      path = if @firm.trading_name?
               edit_self_service_trading_name_path(@firm)
             else
               edit_self_service_firm_path(@firm)
             end

      link_to I18n.t('self_service.firms_index.status.edit_button_text'), path, opts
    end

    def advisers_link(opts = {})
      path = if @firm.advisers.present?
               self_service_firm_advisers_path(@firm)
             else
               new_self_service_firm_adviser_path(@firm)
             end

      link_to I18n.t('self_service.firms_index.status.add_edit_button_text'), path, opts
    end

    def offices_link(opts = {})
      path = if @firm.offices.present?
               self_service_firm_offices_path(@firm)
             else
               new_self_service_firm_office_path(@firm)
             end

      link_to I18n.t('self_service.firms_index.status.add_edit_button_text'), path, opts
    end

    def advisers_count
      @firm.advisers.count
    end

    def offices_count
      @firm.offices.count
    end

    private

    def icon_toggle(condition_met)
      condition_met ? 'tick' : 'exclamation'
    end

    def remote?
      @firm.primary_advice_method == :remote
    end
  end
end
