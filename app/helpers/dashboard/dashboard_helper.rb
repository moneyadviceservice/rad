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
      all_advisers(firm).length
    end

    def most_recently_edited_advisers(firm)
      return [] if firm.advisers.empty?

      number_of_entries = 3
      result = Array.new(number_of_entries)
      advisers = all_advisers(firm).sort_by(&:updated_at).reverse.first(number_of_entries)

      advisers.each_with_index do |adviser, index|
        result[index] = adviser
      end

      result
    end

    private

    def all_advisers(firm)
      result = firm.advisers
      firm.trading_names.each do |trading_names|
        result += trading_names.advisers
      end
      result
    end
  end
end
