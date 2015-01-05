class IdentityConfirmedPage < SitePrism::Page
  set_url '/principals/{id}'
  set_url_matcher %r{/principals/[a-f0-9]{8}}
end
