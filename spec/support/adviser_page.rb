class AdviserPage < SitePrism::Page
  set_url 'principals/{principal}/firm/advisers/new'
  set_url_matcher %r{/principals/[a-f0-9]{8}/firm/advisers/new}
end
