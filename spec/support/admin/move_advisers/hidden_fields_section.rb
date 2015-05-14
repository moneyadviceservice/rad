module Admin
  module MoveAdvisers
    class HiddenFieldsSection < SitePrism::Section
      elements :advisers, '.t-adviser'
      element :destination_firm_id, '.t-destination-firm-id'
      element :destination_firm_fca_number, '.t-destination-firm-fca-number'
    end
  end
end
