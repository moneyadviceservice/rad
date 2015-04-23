namespace :notify do
  desc 'existing firms need notified to sign up'
  task existing_firms_to_sign_up: :environment do
    Principal.all.each do |p|
      user = User.find_by_principal_token p.token

      if user.nil?
        new_user = User.create({
          :principal_token => p.token,
          email: p.email_address,
          password: 'password',
          password_confirmation: 'password'
        })
        new_user.send_reset_password_instructions
      end
    end
  end
end
