module Tasks
  class ExistingFirmsSignUpTask
    def self.notify(inviter, output = STDOUT)
      valid_registered_parent_firms.each do |firm|
        principal = firm.principal
        user = User.find_by_principal_token principal.token
        next if user.present?

        user = invite principal
        output << CSV.generate_line(build_csv_data(inviter, user, firm))
      end
    end

    def self.build_csv_data(inviter, user, firm)
      result = []
      result << firm.fca_number
      result << firm.registered_name
      result << user.principal.full_name
      result << user.principal.email_address
      result << inviter.invitation_url(user)
      result
    end

    def self.invite(principal)
      User.invite!(
        principal_token: principal.token,
        email: principal.email_address,
        skip_invitation: true,
        invitation_sent_at: DateTime.current
      )
    end

    def self.valid_registered_parent_firms
      Firm.registered.all.select { |f| f.valid? && f.parent.nil? }
    end
  end
end
