class Admin::FirmsIndexPage < SitePrism::Page
  set_url '/admin/firms'
  set_url_matcher %r{/admin/firms}

  class RowSection < SitePrism::Section
    element :fca_number_elem, '.t-fca-number'
    element :registered_name_elem, '.t-registered-name'

    def fca_number
      fca_number_elem.text
    end

    def registered_name
      registered_name_elem.text
    end
  end

  element :page_entries_info, '.t-page-entries-info'
  element :fca_number_field, '.t-fca-number-field'
  element :registered_name_field, '.t-registered-name-field'
  sections :firms, RowSection, '.t-firm-row'
  element :submit, '.t-submit'

  def fill_out_form(field_values)
    field_values.each { |field, value| public_send("#{field}_field").set(value) }
  end

  def clear_form
    fill_out_form(fca_number: '', registered_name: '')
  end

  def total_firms
    page_entries_info.text.match(%r{Displaying( all)? (\d) firms?}) do |match_data|
      match_data[2].to_i
    end
  end
end
