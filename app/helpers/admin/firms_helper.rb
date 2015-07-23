module Admin::FirmsHelper
  def render_questionnaire_response(firm, attribute_name)
    value = firm.send(attribute_name)

    if value.present?
      if value.respond_to?(:collect)
        output = value.collect(&:name).to_sentence
      elsif value.respond_to?(:name)
        output = value.name
      else
        output = render_literal_or_fee_or_percentage(value, attribute_name)
      end
      output
    else
      'not set'
    end
  end

  def user_for(principal)
    User.find_by_principal_token principal.token
  end

  private

  def render_literal_or_fee_or_percentage(value, attribute_name)
    output = value.to_s
    output = "£#{output}" if attribute_name =~ /fee/
    output = "#{output}%" if attribute_name =~ /percent/
    output
  end
end
