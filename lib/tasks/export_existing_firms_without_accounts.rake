namespace :principals do
  desc 'existing firms needing notified to sign up'
  task generate_invitations_csv: :environment do
    Tasks::ExistingFirmsSignUpTask.notify(Tasks::UserInvitationHelper.new)
  end
end
