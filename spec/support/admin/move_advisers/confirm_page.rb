module Admin
  module MoveAdvisers
    class ConfirmPage < SitePrism::Page
      set_url_matcher %r{/admin/firms/[0-9]+/move_advisers/confirm}

      element :validation_errors, '.t-errors'
      element :from_firm, '.t-from-firm'
      element :destination_firm, '.t-destination-firm'
      elements :advisers, '.t-adviser'
      element :move, '.t-move'
    end
  end
end
