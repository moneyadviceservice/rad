#!/bin/bash -l

set -e

export PATH=./bin:$PATH
export RAILS_ENV=test
export BUNDLE_WITHOUT=development

function run {
    declare -a tests_command=("$@")
    echo ''
    echo "=== Running \`${tests_command[*]}\`"
    if ! ${tests_command[*]}; then
        echo "=== These tests failed."
        exit 1
    fi
}

function info {
    declare -a info_command=("$@")
    echo ''
    echo "=== Running for informational purposes \`${info_command[*]}\`"
    if ! ${info_command[*]}; then
        echo "== This test has errors and/or warnings. Please review results"
    fi
}

run bundle install --quiet
run npm install
run bundle update brakeman --quiet
run bundle exec bowndler install --allow-root
run mv config/cloud_storage{.example,}.yml
run mv config/database{.example,}.yml
run bundle exec rake db:drop db:setup
#run bundle exec rspec
run bundle exec ./node_modules/.bin/karma start spec/javascripts/karma.conf.js --single-run
run bundle exec cucumber
run bundle exec rubocop -DS
info bundle exec brakeman -q --no-pager --ensure-latest

if [ -f /.dockerenv ]; then
  run bundle exec danger --dangerfile=jenkins/Dangerfile --verbose
fi
