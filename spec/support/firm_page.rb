class FirmPage < SitePrism::Page
  set_url 'principals/{principal}/firm'
  set_url_matcher %r{/principals/[a-f0-9]{8}/firm}
end
