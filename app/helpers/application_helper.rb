module ApplicationHelper
  def validation_summary_with_devise_alerts(form:)
    form.object.errors.add(:base, flash[:alert]) if flash[:alert]
    content_tag :div, form.validation_summary, class: 't-devise-form-errors'
  end
end
