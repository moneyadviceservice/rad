module ApplicationHelper
  def devise_layout
    content_tag :div, class: 'l-constrained' do
      content_tag :div, class: 'l-registration' do
        yield
      end
    end
  end

  def display_adviser_sign_in?
    current_user.nil?
  end

  def display_adviser_sign_out?
    current_user.present?
  end

  def validation_summary_with_devise_alerts(form:)
    form.object.errors.add(:base, flash[:alert]) if flash[:alert]
    content_tag :div, form.validation_summary, class: 't-devise-form-errors'
  end
end
