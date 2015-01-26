class AdviserConfirmationPage < SitePrism::Page
  set_url '/principals/{principal}/firms/{firm}/advisers/{id}'
  set_url_matcher %r{/principals/[a-f0-9]{8}/firms/\d+/advisers/\d+}

  element :add_another, '.t-add-another'
  element :go_to_landing_page, '.t-landing-page'
end
