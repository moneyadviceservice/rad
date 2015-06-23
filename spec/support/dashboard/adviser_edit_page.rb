module SelfService
  class AdviserEditPage < SitePrism::Page
    set_url '/selfservice/firms/{firm}/advisers/{adviser}'
    set_url_matcher %r{/selfservice/firms/\d+/advisers/\d+}

    element :adviser_postcode, '.t-postcode'
    element :travel_distance, '.t-travel-distance'
    element :flash_message, '.t-flash-message'
    element :validation_summary, '.t-validation-summary'

    elements :accreditations, '.t-accreditation-id'
    elements :qualifications, '.t-qualification-id'

    element :save_button, '.t-submit'
  end
end
