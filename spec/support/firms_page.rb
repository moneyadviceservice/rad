class FirmsPage < SitePrism::Page
  set_url 'principals/{principal}/firms'
  set_url_matcher %r{/principals/[a-f0-9]{8}/firms}
end
