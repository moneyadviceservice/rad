class FirmPage < SitePrism::Page
  set_url 'principals/{principal}/firm'
  set_url_matcher %r{/principals/[a-f0-9]{8}/firm}

  element :firm_title, '.t-firm-title'
  element :firm_questionnaire, '.t-firm-questionnaire'

  elements :subsidiaries, '.t-subsidiary'
  elements :subsidiary_questionnaires, '.t-subsidiary-questionnaire'
end
