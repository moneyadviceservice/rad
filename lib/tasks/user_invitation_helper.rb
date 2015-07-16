module Tasks
  class UserInvitationHelper
    def invitation_url(user)
      app = Rails.application
      host = app.config.action_mailer.default_url_options[:host]
      app.routes.url_helpers.accept_user_invitation_url(invitation_token: user.raw_invitation_token, host: host)
    end
  end
end
