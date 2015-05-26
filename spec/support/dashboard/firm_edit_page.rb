module Dashboard
  class FirmEditPage < SitePrism::Page
    set_url '/dashboard/firms/{firm}'
    set_url_matcher %r{/dashboard/firms/\d+}

    element :flash_message, '.t-flash-message'
    element :validation_summary, '.t-validation-summary'
    element :firm_name, '.t-firm-name'
    element :firm_email_field, '.t-firm-email-field'
    element :save_button, '.t-save-button'
  end
end
