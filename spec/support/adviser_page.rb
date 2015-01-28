class AdviserPage < SitePrism::Page
  set_url '/principals/{principal}/firms/{firm}/advisers/new'
  set_url_matcher %r{/principals/[a-f0-9]{8}/firms/\d+/advisers/new}

  element :reference_number, '.t-reference-number'
  element :postcode, '.t-postcode'
  element :travel_distance, '.t-travel-distance'
  element :confirmed_disclaimer, '.t-confirmed-disclaimer'
  element :submit, '.t-submit'

  element :does_cover_whole_of_uk, '#adviser_covers_whole_of_uk_true'
  element :does_not_cover_whole_of_uk, '#adviser_covers_whole_of_uk_false'

  def adviser_unmatched?
    first(
      '.validation-summary__error',
      text: I18n.t('questionnaire.adviser.reference_number_un_matched')
    )
  end

  def matched_adviser?(name)
    has_content?(name)
  end
end
