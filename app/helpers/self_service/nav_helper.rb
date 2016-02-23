module SelfService
  module NavHelper
    def self_service_firm_details_url(firm)
      return edit_self_service_trading_name_path(firm) if firm.trading_name?

      edit_self_service_firm_path(firm)
    end

    def tab_link(url_path, css_classes, &content_block)
      active_link_to(url_path,
                     class: css_classes,
                     class_active: 'is-active',
                     class_inactive: 'is-inactive',
                     &content_block)
    end
  end
end
