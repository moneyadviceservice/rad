module Dashboard
  module DashboardHelper
    def firm_count
      @trading_names.count + (@firm.present? ? 1 : 0)
    end

    def filter_field(name, locale_prefix:)
      content_tag :div, class: 'filter-field' do
        concat label_tag "#{name}_filter", t("#{locale_prefix}_label"), class: 'filter-field__label'
        concat text_field_tag "#{name}_filter",
                              nil,
                              placeholder: t("#{locale_prefix}_placeholder"),
                              class: 'filter-field__input js-filter-field'
      end
    end

    def add_adviser_button(firm:)
      label = t('dashboard.advisers_index.add_adviser_button')
      sr_label = t('dashboard.advisers_index.add_adviser_button_full', firm_name: firm.registered_name)
      link_to new_dashboard_firm_adviser_path(firm), class: 'button button--primary' do
        concat content_tag(:span, label, 'aria-hidden' => true)
        concat content_tag(:span, sr_label, class: 'visually-hidden')
      end
    end

    def number_of_advisers(firm)
      all_advisers_for_firm_and_trading_names(firm).size
    end

    def most_recently_edited_advisers(firm, limit = 3)
      all_advisers_for_firm_and_trading_names(firm).order(updated_at: 'DESC').limit(limit)
    end

    def all_advisers_for_firm_and_trading_names(firm)
      firms = Firm.where(fca_number: firm.fca_number)
      Adviser.where(firm: firms)
    end
  end
end
