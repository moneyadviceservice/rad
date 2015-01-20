class QuestionnairePage < SitePrism::Page
  set_url 'principals/{principal}/firm/questionnaire/new'
  set_url_matcher %r{/principals/[a-f0-9]{8}/firm/questionnaire(/new)?}

  element :firm_name, '.t-firm-name'
  element :firm_fca_number, '.t-firm-fca-number'

  element :email_address_field, '#firm_email_address'
  element :telephone_number_field, '#firm_telephone_number'

  element :next_button, '.l-questionnaire__button button'
end
