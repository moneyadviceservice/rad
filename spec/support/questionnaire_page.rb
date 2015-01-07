class QuestionnairePage < SitePrism::Page
  set_url 'principals/{principal}/firm/questionnaire'
  set_url_matcher %r{/principals/[a-f0-9]{8}/firm/questionnaire}
end
