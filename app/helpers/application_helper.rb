module ApplicationHelper
  def validation_summary_with_devise_alerts(form:)
    form.object.errors.add(:base, flash[:alert]) if flash[:alert]
    content_tag :div, form.validation_summary, class: 't-devise-form-errors'
  end

  def render_breadcrumbs(crumbs)
    content_for :breadcrumbs do
      render 'shared/breadcrumbs', breadcrumbs: crumbs
    end
  end

  def register_path
    prequalify_principals_path
  end

  def required_asterisk(string)
    string + "\u00a0*" # \u00a0 is a non breaking space
  end

  def paragraphs(paragraph_list, html_options = {})
    tags = Array(paragraph_list).map do |paragraph|
      content_tag :p, paragraph, html_options
    end
    safe_join(tags)
  end

  def layout_class
    controller.devise_controller? ? 'l-registration' : 'l-content'
  end
end
