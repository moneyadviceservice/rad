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

    def add_adviser_button(firm:)
      label = t('self_service.advisers_index.add_adviser_button')
      sr_label = t('self_service.advisers_index.add_adviser_button_full', firm_name: firm.registered_name)
      link_to new_self_service_firm_adviser_path(firm), class: 'button button--primary' do
        concat content_tag(:span, label, 'aria-hidden' => true)
        concat content_tag(:span, sr_label, class: 'visually-hidden')
      end
    end

    def add_office_button(firm:)
      label = t('self_service.offices_index.add_office_button')
      sr_label = t('self_service.offices_index.add_office_button_full', firm_name: firm.registered_name)
      link_to new_self_service_firm_office_path(firm), class: 'button button--primary' do
        concat content_tag(:span, label, 'aria-hidden' => true)
        concat content_tag(:span, sr_label, class: 'visually-hidden')
      end
    end

    def create_or_update_self_service_trading_names_path(firm)
      return self_service_trading_name_path(firm) if firm.persisted?
      self_service_trading_names_path
    end

    def office_address_table_cell(office)
      [
        :address_line_one,
        :address_line_two,
        :address_town,
        :address_county
      ].map { |field| office.send(field) }
        .reject(&:blank?)
        .join(', ')
    end

    def render_onboarding_message(page)
      render partial: "self_service/onboarding/#{page}",
             locals: { principal: current_user.principal }
    end
  end
end
