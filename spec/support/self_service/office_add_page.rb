require_relative 'office_edit_page'

module SelfService
  class OfficeAddPage < OfficeEditPage
    set_url '/self_service/firms/{firm}/offices/new'
    set_url_matcher %r{/self_service/firms/\d+/offices/new}
  end
end
