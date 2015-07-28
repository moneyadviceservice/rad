module SignInPanelHelper
  def sign_in_resource_name
    # This must match the value passed to `devise_for` in routes.rb
    :user
  end

  def sign_in_resource
    @sign_in_resource ||= Devise.mappings[sign_in_resource_name].to.new
  end
end
