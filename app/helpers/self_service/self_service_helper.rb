module SelfService
  module SelfServiceHelper
    def filter_field(name, locale_prefix:)
      content_tag :div, class: 'filter-field' do
        concat label_tag "#{name}_filter", t("#{locale_prefix}_label"), class: 'filter-field__label'
        concat text_field_tag "#{name}_filter",
                              nil,
                              placeholder: t("#{locale_prefix}_placeholder"),
                              class: 'filter-field__input',
                              'data-dough-filter-input' => true
      end
    end

    def firm_type_label(firm)
      type = (firm.trading_name?) ? :trading_name : :main_firm
      I18n.t("self_service.#{type}")
    end

    def add_adviser_button(firm:)
      label = t('self_service.advisers_index.add_adviser_button')
      sr_label = t('self_service.advisers_index.add_adviser_button_full', firm_name: firm.registered_name)
      link_to new_self_service_firm_adviser_path(firm), class: 'button button--primary' do
        concat content_tag(:span, label, 'aria-hidden' => true)
        concat content_tag(:span, sr_label, class: 'visually-hidden')
      end
    end
  end
end
