module SelfService
  module SelfServiceHelper
    def filter_field(name, locale_prefix:)
      content_tag :div, class: 'filter-field' do
        concat label_tag "#{name}_filter", t("#{locale_prefix}_label"),
                         class: 'filter-field__label'
        concat text_field_tag "#{name}_filter",
                              nil,
                              placeholder: t("#{locale_prefix}_placeholder"),
                              class: 'filter-field__input',
                              'data-dough-filter-input' => true
      end
    end

    def add_adviser_button(firm:)
      label = t('self_service.advisers_index.add_adviser_button')
      sr_label = t('self_service.advisers_index.add_adviser_button_full',
                   firm_name: firm.registered_name)
      link_to new_self_service_firm_adviser_path(firm),
              class: 'button button--primary' do
        concat content_tag(:span, label, 'aria-hidden' => true)
        concat content_tag(:span, sr_label, class: 'visually-hidden')
      end
    end

    def add_office_button(firm:)
      key = if firm.main_office.present?
              :add_office_button
            else
              :add_main_office_button
            end
      label = t("self_service.offices_index.#{key}")
      sr_label = t('self_service.offices_index.add_office_button_full',
                   firm_name: firm.registered_name)
      link_to new_self_service_firm_office_path(firm),
              class: 'button button--primary' do
        concat content_tag(:span, label, 'aria-hidden' => true)
        concat content_tag(:span, sr_label, class: 'visually-hidden')
      end
    end

    def create_or_update_self_service_trading_names_path(firm)
      return self_service_trading_name_path(firm) if firm.persisted?
      self_service_trading_names_path
    end

    def office_address_table_cell(office)
      %i[
        address_line_one
        address_line_two
        address_town
        address_county
      ].map { |field| office.send(field) }
        .reject(&:blank?)
        .join(', ')
    end

    def first_onboarded_firm_for(principal)
      principal.main_firm_with_trading_names.onboarded.first
    end

    def firm_language_select(value, html_options = {})
      options = options_from_collection_for_select(
        Languages::AVAILABLE_LANGUAGES,
        :iso_639_3,
        :common_name,
        value
      )
      select_tag('firm[languages][]', options,
                 {
                   prompt: t('self_service.firm_form.languages_select_prompt')
                 }.merge(html_options))
    end

    def firm_language_delete_button
      content_tag(:button,
                  type: 'button',
                  class: 'button-link language-selector__delete',
                  'data-dough-language-selector-delete-language' => true) do
        t('self_service.firm_form.languages_delete_language')
      end
    end

    def status_icon(icon_type)
      content_tag :svg, class: "status__icon status__icon--#{icon_type}" do
        tag :use, 'xlink:href': "#icon-#{icon_type}"
      end
    end
  end
end
