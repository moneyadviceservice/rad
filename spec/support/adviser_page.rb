class AdviserPage < SitePrism::Page
  set_url '/principals/{principal}/firm/advisers/new'
  set_url_matcher %r{/principals/[a-f0-9]{8}/firm/advisers/new}

  element :reference_number, '.t-reference-number'
  element :postcode, '.t-postcode'
  element :travel_distance, '.t-travel-distance'
  element :confirmed_disclaimer, '.t-confirmed-disclaimer'
  element :submit, '.t-submit'

  def adviser_unmatched?
    first(
      '.validation-summary__error',
      text: I18n.t('questionnaire.adviser.reference_number_un_matched')
    )
  end

  def matched_adviser?(name)
    has_content?(name)
  end

  def covers_whole_of_uk(v)
    key = I18n.t('questionnaire.adviser.geographical_coverage.covers_whole_of_uk')
    v ? check(key) : uncheck(key)
  end
end
