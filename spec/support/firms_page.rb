class FirmsPage < SitePrism::Page
  set_url '/firms{?query*}'
  set_url_matcher /\/firms(:?(\?.*)?)$/
end
