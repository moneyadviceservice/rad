class Admin::FirmsIndexPage < SitePrism::Page
  set_url '/admin/retirement_firms'
  set_url_matcher %r{/admin/retirement_firms}

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

  element :retirement_income_products_flag_field, '.t-retirement-income-products-flag-field'
  element :pension_transfer_flag_field, '.t-pension-transfer-flag-field'
  element :long_term_care_flag_field, '.t-long-term-card-flag-field'
  element :equity_release_flag_field, '.t-equity-release-flag-field'
  element :inheritance_tax_and_estate_planning_flag_field, '.t-inheritance-tax-and-estate-planning-flag-field'
  element :wills_and_probate_flag_field, '.t-wills-and-probate-flag-field'

  element :languages_field, '.t-languages-field'
  element :submit, '.t-submit'

  sections :firms, RowSection, '.t-firm-row'

  def total_results_regexp
    %r{Displaying( all)? (\d) firms?}
  end

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
    page_entries_info.text.match(
      total_results_regexp
    ) do |match_data|
      match_data[2].to_i
    end
  end
end
