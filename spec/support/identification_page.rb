class IdentificationPage < SitePrism::Page
  set_url '/principals/new'
  set_url_matcher /new/

  element :reference_number, '.t-reference-number'
  element :website_address, '.t-website-address'
  element :first_name, '.t-first-name'
  element :last_name, '.t-last-name'
  element :job_title, '.t-job-title'
  element :email_address, '.t-email-address'
  element :telephone_number, '.t-telephone-number'
  element :confirmation, '.t-confirmation'

  element :register, '.button--primary'

  def firm_unmatched?
    find(
      '.validation-summary__error',
      text: I18n.t('registration.principal.fca_number_un_matched')
    )
  end

  def errored?
    find('.global-alert--error')
  end
end
