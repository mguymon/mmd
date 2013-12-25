ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
require "minitest/pride"


DatabaseCleaner.strategy = :transaction

class ActiveSupport::TestCase
  self.use_transactional_fixtures = false

  before do
    DatabaseCleaner.start
  end

  after do
    DatabaseCleaner.clean
  end
end


class MiniTest::Spec

  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end

# Make all database transactions use the same thread
ActiveRecord::ConnectionAdapters::ConnectionPool.class_eval do
  def current_connection_id
    Thread.main.object_id
  end
end
