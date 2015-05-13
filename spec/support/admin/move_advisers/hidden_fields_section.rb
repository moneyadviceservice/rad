module Admin
  module MoveAdvisers
    class HiddenFieldsSection < SitePrism::Section
      elements :advisers, '.t-adviser'
      element :destination_firm_id, '.t-destination_firm_id'
      element :destination_firm_fca_number, '.t-destination_firm_fca_number'
    end
  end
end
