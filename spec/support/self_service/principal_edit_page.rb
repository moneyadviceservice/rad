module SelfService
  class PrincipalEditPage < SitePrism::Page
    set_url '/self_service/principals/{principal_id}/edit'
    set_url_matcher %r{/self_service/principals/\d+/edit}

    element :flash_message, '.t-flash-message'
    element :validation_summary, '.t-validation-summary'

    element :first_name, '.t-first-name'
    element :last_name, '.t-last-name'
    element :job_title, '.t-job-title'
    element :email_address, '.t-email-address'
    element :telephone_number, '.t-telephone-number'

    element :save_button, '.t-save-button'
  end
end
