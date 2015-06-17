# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

require 'rake/file_utils'
include FileUtils

KARMA_COMMAND = 'node_modules/.bin/karma'
JSHINT_COMMAND = 'node_modules/.bin/jshint'

def described_task(name, description:)
  task name do
    puts
    puts "Running #{description}"
    puts
    yield
    puts
  end
end

described_task :karma, description: 'Javascript Karma specs' do
  fail 'ERROR: karma is not installed' unless File.exist? KARMA_COMMAND
  sh "#{KARMA_COMMAND} start spec/javascripts/karma.conf.js --single-run=true"
end

described_task :jshint, description: 'JSHint' do
  fail 'ERROR: JSHint is not installed' unless File.exist? JSHINT_COMMAND
  sh "#{JSHINT_COMMAND} app/assets/javascripts spec/javascripts" do
    puts 'JSHint found no style violations.'
  end
end

if Rails.env.production?
  task :default
else
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
  task default: [:spec, :karma, :rubocop, :jshint]
end
