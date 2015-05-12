class AdminAdviserPage < SitePrism::Page
  set_url '/admin/advisers/{adviser}'
  set_url_matcher %r{/admin/advisers/[a-f0-9]{8}}

  element :delete_adviser, '.t-delete-adviser'
end
