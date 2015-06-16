module Dashboard
  class AdvisersTableRowSection < SitePrism::Section
    element :reference_number, '.t-adviser-reference-number'
    element :name, '.t-adviser-name'
    element :postcode, '.t-adviser-postcode'
    element :edit_link, '.t-edit-link'
  end
end
