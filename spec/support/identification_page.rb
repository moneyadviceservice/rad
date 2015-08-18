class IdentificationPage < SitePrism::Page
  set_url '/principals/new'
  set_url_matcher(/new/)

  elements :validation_summaries, '.validation-summary__error'

  element :reference_number, '.t-reference-number'
  element :first_name, '.t-first-name'
  element :last_name, '.t-last-name'
  element :job_title, '.t-job-title'
  element :email, '.t-email-address'
  element :password, '.t-password'
  element :password_confirmation, '.t-password-confirmation'
  element :telephone_number, '.t-telephone-number'
  element :confirmation, '.t-confirmation'

  element :register, '.button--primary'

  def firm_unmatched?
    first(
      '.validation-summary__error',
      text: I18n.t('registration.principal.fca_number_unmatched')
    )
  end

  def errored?
    find('.global-alert--error')
  end
end
