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

end
