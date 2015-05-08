module Admin
  module MoveAdvisers
    class HiddenFieldsSection < SitePrism::Section
      elements :advisers, '.t-adviser'
      element :to_firm_id, '.t-to_firm_id'
    end
  end
end
