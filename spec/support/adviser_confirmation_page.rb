class AdviserConfirmationPage < SitePrism::Page
  set_url 'principals/{principal}/firm/advisers/{id}'
  set_url_matcher %r{/principals/[a-f0-9]{8}/firm/advisers/\d+}

  element :add_another, '.t-add-another'
end
