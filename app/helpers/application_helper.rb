module ApplicationHelper
  def devise_layout
    content_tag :div, class: 'l-constrained' do
      content_tag :div, class: 'l-registration' do
        yield
      end
    end
  end
end
