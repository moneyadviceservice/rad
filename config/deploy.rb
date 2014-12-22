lock '3.2.1'

set :application, 'rad'
set :repo_url, 'https://github.com/moneyadviceservice/rad.git'
set :deploy_to, '/home/deploy/rad'
set :linked_files, %w{config/database.yml}

set :rails_env, 'production'

set :ssh_options, {
  auth_methods: %w(publickey)
}

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute 'sudo restart rad'
    end
  end

  after :publishing, :restart
end
