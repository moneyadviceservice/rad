module RSpec
  module Matchers
    # Works around Capybara/RSpec collision: https://github.com/jnicklas/capybara/issues/1396
    alias_method :rspec_all, :all
  end
end
