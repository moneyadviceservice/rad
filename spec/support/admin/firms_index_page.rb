class Admin::FirmsIndexPage < SitePrism::Page
  set_url '/admin/firms'
  set_url_matcher %r{/admin/firms}

  class RowSection < SitePrism::Section
    element :fca_number_elem, '.t-fca-number'
    element :registered_name_elem, '.t-registered-name'
    element :approved_elem, 'td:last-child'

    def fca_number
      fca_number_elem.text
    end

    def registered_name
      registered_name_elem.text
    end

    def approved
      approved_elem.text
    end
  end

  element :page_entries_info, '.t-page-entries-info'

  element :fca_number_field, '.t-fca-number-field'
  element :registered_name_field, '.t-registered-name-field'
  element :ethical_investing_flag_field, '.t-ethical-investing-flag-field'
  element :sharia_investing_flag_field, '.t-sharia-investing-flag-field'
  element :workplace_financial_advice_flag_field, '.t-workplace-financial-advice-flag'
  element :languages_field, '.t-languages-field'
  element :submit, '.t-submit'
  elements :xfirms, '.t-firm-row'
  elements :fca_unverified_firms, '.alert-warning'

  sections :firms, RowSection, '.t-firm-row'

  def fill_out_form(field_values)
    field_values.each { |field, value| public_send("#{field}_field").set(value) }
  end

  def clear_form
    fill_out_form(fca_number: '',
                  registered_name: '',
                  ethical_investing_flag: false,
                  sharia_investing_flag: false,
                  workplace_financial_advice_flag: false,
                  languages: false)
  end

  def total_firms
    page_entries_info.text.match(%r{Displaying( all)? (\d) firms?}) do |match_data|
      match_data[2].to_i
    end
  end
end
