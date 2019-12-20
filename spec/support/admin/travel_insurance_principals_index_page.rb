class Admin::TravelInsurancePrincipalsIndexPage < SitePrism::Page
  set_url '/admin/travel_insurance_principals'
  set_url_matcher %r{/admin/travel_insurance_principals}

  class RowSection < SitePrism::Section
    element :fca_number_elem, '.t-fca-number'
    element :registered_name_elem, '.t-registered-name'

    def registered_name
      registered_name_elem.text
    end
  end

  element :page_entries_info, '.t-page-entries-info'

  element :fca_number_field, '.t-fca-number-field'
  element :registered_name_field, '.t-registered-name-field'
  element :submit, '.t-submit'

  sections :principals, RowSection, '.t-principal-row'

  def fill_out_form(field_values)
    field_values.each do |field, value|
      public_send("#{field}_field").set(value)
    end
  end

  def clear_form
    fill_out_form(fca_number: '', registered_name: '')
  end

  def total_results_regexp
    %r{Displaying( all)? (\d) principals?}
  end

  def total_principals
    return 0 if page_entries_info.text == 'No principals found'

    page_entries_info.text.match(
      total_results_regexp
    ) do |match_data|
      match_data[2].to_i
    end
  end
end
