module RSpec
  module Matchers
    # Works around Capybara/RSpec collision: https://github.com/jnicklas/capybara/issues/1396
    alias rspec_all all
  end
end
