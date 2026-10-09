ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require_relative "test_helpers/session_test_helper"

# Random password for fixture users, so no password is hardcoded. Set before workers fork.
ENV["TEST_USER_PASSWORD"] ||= SecureRandom.base58(24)

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def fixture_password
      ENV.fetch("TEST_USER_PASSWORD")
    end
  end
end
