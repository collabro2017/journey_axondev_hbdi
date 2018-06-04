ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'helpers/postgres_helper'
require 'rails/test_help'
require "minitest/spec"
require "minitest/rails/capybara"
require 'helpers/fixtures_helper'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
