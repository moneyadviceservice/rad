class AdviserPage < SitePrism::Page
  set_url 'principals/{principal}/firm/advisers/new'
  set_url_matcher %r{/principals/[a-f0-9]{8}/firm/advisers/new}

  element :reference_number, '.t-reference-number'
  element :confirmed_disclaimer, '.t-confirmed-disclaimer'
  element :submit, '.t-submit'

  def adviser_unmatched?
    first(
      '.validation-summary__error',
      text: I18n.t('questionnaire.adviser.reference_number_un_matched')
    )
  end
end
