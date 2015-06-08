class AcceptInvitationPage < SitePrism::Page
  set_url '/users/invitation/accept?invitation_token={invitation_token}'
  set_url_matcher %r{/users/invitation(/accept\?invitation_token=[^&]+)?}

  element :password, '.t-password-field'
  element :password_confirmation, '.t-password-confirmation-field'
  element :submit, '.t-submit-button'
  element :devise_form_errors, '.t-devise-form-errors'
end
