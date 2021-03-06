module Admin::FirmsHelper
  def render_questionnaire_response(firm, attribute_name)
    value = firm.send(attribute_name)

    if value.present?
      output = if value.respond_to?(:collect)
                 value.collect(&:name).to_sentence
               elsif value.respond_to?(:name)
                 value.name
               else
                 render_literal_or_fee_or_percentage(value, attribute_name)
               end
      output
    else
      'not set'
    end
  end

  def render_inline_language_list(firm)
    firm.languages
        .map(&LanguageList::LanguageInfo.method(:find))
        .map(&:common_name)
        .sort
        .join(', ')
  end

  def user_for(principal)
    User.find_by(principal_token: principal.token)
  end

  private

  def render_literal_or_fee_or_percentage(value, attribute_name)
    output = value.to_s
    output = "£#{output}" if attribute_name =~ /fee/
    output = "#{output}%" if attribute_name =~ /percent/
    output
  end

  def travel_registration_questions
    TravelInsuranceFirm::KNOWN_REGISTRATION_QUESTIONS.filter { |question| get_answer(question) != 'EMPTY' }
  end

  def get_answer(question)
    @firm.send(question.to_sym) || 'EMPTY'
  end
end
