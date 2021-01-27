module SelfService
  class StatusPresenter < SimpleDelegator
    include Rails.application.routes.url_helpers
    include ActionView::Helpers::UrlHelper

    def overall_status
      if hidden?
        'hidden'
      elsif publishable?
        'published'
      else
        'unpublished'
      end
    end

    def overall_status_icon
      icon_toggle(publishable? || hidden?)
    end

    def firm_details_icon
      icon_toggle onboarded?
    end

    def advisers_icon
      icon_toggle advisers?
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

      label = if onboarded?
                I18n.t('self_service.status.edit')
              else
                I18n.t('self_service.status.add')
              end

      link_to label, path, opts
    end

    def advisers_link(opts = {})
      if advisers.present?
        path = self_service_firm_advisers_path(self)
        text = I18n.t('self_service.status.edit')
      else
        path = new_self_service_firm_adviser_path(self)
        text = I18n.t('self_service.status.add')
      end

      link_to text, path, opts
    end

    def offices_link(opts = {})
      if offices.present?
        path = self_service_firm_offices_path(self)
        text = I18n.t('self_service.status.edit')
      else
        path = new_self_service_firm_office_path(self)
        text = I18n.t('self_service.status.add')
      end

      link_to text, path, opts
    end

    def needs_advisers?
      !advisers?
    end

    def needs_offices?
      offices.none?
    end

    private

    def icon_toggle(condition_met)
      condition_met ? 'tick' : 'exclamation'
    end

    def remote?
      primary_advice_method == :remote
    end

    def advisers?
      advisers.any?
    end
  end
end
