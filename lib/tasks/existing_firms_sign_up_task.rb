module Tasks
  class ExistingFirmsSignUpTask
    def self.notify
      valid_registered_parent_firms.each do |firm|
        principal = firm.principal
        user = User.find_by_principal_token principal.token

        if user.nil?
          invite principal
        elsif user.invited_to_sign_up? && !user.invitation_accepted?
          user.invite!
        end
      end
    end

    def self.invite(principal)
      User.invite!(
        principal_token: principal.token,
        email: principal.email_address
      )
    end

    def self.valid_registered_parent_firms
      Firm.registered.all.select { |f| f.valid? && f.parent.nil? }
    end
  end
end
