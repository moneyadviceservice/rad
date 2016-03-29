class Admin::AdvisersIndexPage < SitePrism::Page
  set_url '/admin/advisers'
  set_url_matcher %r{/admin/advisers}

  class RowSection < SitePrism::Section
    element :reference_number_elem, '.t-reference-number'
    element :name_elem, '.t-name'
    element :firm_registered_name_elem, '.t-firm-registered-name'
    element :postcode_elem, '.t-postcode'

    def reference_number
      reference_number_elem.text
    end

    def name
      name_elem.text
    end

    def firm_registered_name
      firm_registered_name_elem.text
    end

    def postcode
      postcode_elem.text
    end
  end

  element :page_entries_info, '.t-page-entries-info'
  element :reference_number_field, '.t-reference-number-field'
  element :name_field, '.t-name-field'
  element :firm_registered_name_field, '.t-firm-registered-name-field'
  element :postcode_field, '.t-postcode-field'
  sections :advisers, RowSection, '.t-adviser-row'
  element :submit, '.t-submit'

  def fill_out_form(field_values)
    field_values.each { |field, value| public_send("#{field}_field").set(value) }
  end

  def clear_form
    fill_out_form(reference_number: '', name: '', firm_registered_name: '', postcode: '')
  end

  def total_advisers
    page_entries_info.text.match(%r{Displaying( all)? (\d) advisers?}) do |match_data|
      match_data[2].to_i
    end
  end
end
