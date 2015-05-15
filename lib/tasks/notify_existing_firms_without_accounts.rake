
namespace :notify do
  desc 'existing firms need notified to sign up'
  task existing_firms_to_sign_up: :environment do

    Principal.all.each do |p|
      user = User.find_by_principal_token p.token

      if user.nil?
        new_user = User.invite!({
          :principal_token => p.token,
          email: p.email_address
        })
      end
    end
  end
end
