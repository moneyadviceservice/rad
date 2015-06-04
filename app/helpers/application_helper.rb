module ApplicationHelper
  def validation_summary_with_devise_alerts(form:)
    form.object.errors.add(:base, flash[:alert]) if flash[:alert]
    content_tag :div, form.validation_summary, class: 't-devise-form-errors'
  end

  def render_breadcrumbs(crumbs)
    render 'shared/breadcrumbs', breadcrumbs: crumbs
  end

  def register_path
    prequalify_principals_path
  end
end
