namespace :reports do
  desc 'Run a report to see how many invitations have been acted upon.'
  task invitation_uptake: :environment do
    puts InvitationUptake.new.run
  end
end
