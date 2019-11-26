module Admin
  module MoveAdvisers
    class MoveAdvisersPage < SitePrism::Page
      set_url_matcher %r{/admin/retirement_firms/[0-9]+/move_advisers/new}

      elements :advisers, '.t-adviser'
      element :next, '.t-next'
    end
  end
end
