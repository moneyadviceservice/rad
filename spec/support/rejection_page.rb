class RejectionPage < SitePrism::Page
  set_url '/principal/reject'
  set_url_matcher /reject/

  element :principal_email, '.t-email'
  element :administrator_message, '.t-message'
  element :send_message, '.button--primary'

  element :go_back, '.t-back'

  def valid?
    has_css?('validation-summary--hidden')
  end
end
