module Tasks
  class ExistingFirmsSignUpTask
    def self.notify(inviter, output = STDOUT)
      Principal.all.each do |principal|
        if invitable?(principal)
          user = invite principal
          output << CSV.generate_line(build_csv_data(inviter, user))
        end
      end
    end

    def self.invitable?(principal)
      principal.firm.parent_id.nil? && User.find_by_principal_token(principal.token).nil?
    end

    def self.invite(principal)
      User.invite!(
        principal_token: principal.token,
        email: principal.email_address,
        skip_invitation: true,
        invitation_sent_at: DateTime.current
      )
    end

    def self.build_csv_data(inviter, user)
      principal = user.principal
      firm = principal.firm

      [
        firm.fca_number,
        firm.registered_name,
        principal.full_name,
        principal.email_address,
        inviter.invitation_url(user),
        (firm.email_address.present? ? 'registered' : 'not registered')
      ]
    end
  end
end
