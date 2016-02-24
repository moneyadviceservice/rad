module SelfService
  class StatusPresenter < SimpleDelegator
    include Rails.application.routes.url_helpers
    include ActionView::Helpers::UrlHelper

    def overall_status
      publishable? ? 'published' : 'unpublished'
    end

    def overall_status_icon
      icon_toggle publishable?
    end

    def firm_details_icon
      icon_toggle registered?
    end

    def advisers_icon
      icon_toggle(remote? || advisers.any?)
    end

    def offices_icon
      icon_toggle offices.any?
    end

    def firm_details_link(opts = {})
      path = if trading_name?
               edit_self_service_trading_name_path(self)
             else
               edit_self_service_firm_path(self)
             end

      link_to I18n.t('self_service.firms_index.status.edit'), path, opts
    end

    def advisers_link(opts = {})
      if advisers.present?
        path = self_service_firm_advisers_path(self)
        text = I18n.t('self_service.firms_index.status.edit')
      else
        path = new_self_service_firm_adviser_path(self)
        text = I18n.t('self_service.firms_index.status.add')
      end

      link_to text, path, opts
    end

    def offices_link(opts = {})
      if offices.present?
        path = self_service_firm_offices_path(self)
        text = I18n.t('self_service.firms_index.status.edit')
      else
        path = new_self_service_firm_office_path(self)
        text = I18n.t('self_service.firms_index.status.add')
      end

      link_to text, path, opts
    end

    private

    def icon_toggle(condition_met)
      condition_met ? 'tick' : 'exclamation'
    end

    def remote?
      primary_advice_method == :remote
    end
  end
end
