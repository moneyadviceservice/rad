class AdviserPage < SitePrism::Page
  set_url 'principals/{principal}/advisers/new'
  set_url_matcher %r{/principals/[a-f0-9]{8}/advisers/new}

  element :reference_number, '.t-reference-number'
end
