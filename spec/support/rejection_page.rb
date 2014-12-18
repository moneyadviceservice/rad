class RejectionPage < SitePrism::Page
  set_url '/principal/reject'
  set_url_matcher /reject/

  element :administrator_message, '.t-message'
  element :go_back, '.t-back'
end
