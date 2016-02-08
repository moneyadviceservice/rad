class Admin::NewAdviserPage < SitePrism::Page
  set_url '/admin/firms/{firm_id}/advisers/new'
  set_url_matcher %r{/admin/firms/[0-9]+/advisers(/new)?}

  element :errors, '.t-errors'
  element :name, '.t-name'
  element :postcode, '.t-postcode'
  element :save, '.t-save'
  element :travel_distance, '.t-travel-distance'
end
