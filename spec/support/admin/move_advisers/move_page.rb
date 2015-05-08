module Admin
  module MoveAdvisers
    class MovePage < SitePrism::Page
      set_url_matcher %r{/admin/firms/[0-9]+/move_advisers/move}
    end
  end
end
