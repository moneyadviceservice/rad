# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

require 'rake/file_utils'
include FileUtils

task :karma do
  puts
  puts 'Running JavaScript Karma specs'
  puts
  sh 'node_modules/.bin/karma start spec/javascripts/karma.conf.js --single-run=true'
  puts
end

if Rails.env.production?
  task :default
else
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
  task default: [:spec, :karma, :rubocop]
end
