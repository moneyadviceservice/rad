module Admin
  module MoveAdvisers
    class ConfirmPage < SitePrism::Page
      set_url_matcher %r{/admin/firms/[0-9]+/move_advisers/confirm}

      element :from_firm, '.t-from_firm'
      element :to_firm, '.t-to_firm'
      elements :advisers, '.t-adviser'
      element :move, '.t-move'

      section :hidden, HiddenFieldsSection, '.t-hidden-fields'
    end
  end
end
