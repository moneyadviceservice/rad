class PreQualificationPage < SitePrism::Page
  set_url '/prequalification'
  set_url_matcher /prequalification/

  element :question_1, '.t-question-1'
  element :question_2, '.t-question-2'
  element :question_3, '.t-question-3'
  element :submit, '.button--primary'

  element :error_message, '.global-alert--error'
end
