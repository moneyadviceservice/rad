
namespace :notify do
  desc 'existing firms need notified to sign up'
  task existing_firms_to_sign_up: :environment do
    Tasks::ExistingFirmsSignUpTask.notify
  end
end
