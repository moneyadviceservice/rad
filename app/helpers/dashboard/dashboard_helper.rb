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
  end
end
