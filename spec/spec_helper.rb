# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] = 'test'
require File.expand_path("../test_app/config/environment", __FILE__)
require 'rspec'
require 'rspec/rails'
require 'database_cleaner'
require 'factory_girl'
require 'factory_girl_rails'

include ActionDispatch::TestProcess

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    # Disable the `should` old syntax for consistency.
    c.syntax = :expect
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/fixtures"

  config.include FactoryGirl::Syntax::Methods

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # See http://blog.bignerdranch.com/1617-sane-rspec-config-for-clean-and-slightly-faster-specs/
  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  # Request specs cannot use a transaction because Capybara runs in a
  # separate thread with a different database connection.
  config.before type: :request do
    DatabaseCleaner.strategy = :truncation
  end

  # Reset so other non-request specs don't have to deal with slow truncation.
  config.after type: :request  do
    DatabaseCleaner.strategy = :transaction
  end

  config.before do
    DatabaseCleaner.start
    ActionMailer::Base.deliveries.clear
  end

  config.after do
    DatabaseCleaner.clean
  end

  # Disable GC during rspec tests
  # See http://railscasts.com/episodes/413-fast-tests?view=asciicast
  #config.before(:all) do
  #  DeferredGarbageCollection.start
  #end
  #
  #config.after(:all) do
  #  DeferredGarbageCollection.reconsider
  #end

  # If specs have the :focus tag then running rspec will only run specs
  # See http://railscasts.com/episodes/413-fast-tests?view=asciicast
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  # Exclude slower specs, e.g. external API calls, unless $SLOW_SPECS is set
  config.filter_run_excluding :slow unless ENV['SLOW_SPECS']

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
  # Check if encryption key is set before starting tests to save headaches

  # For get() and last_response() methods for API testing
  # config.include Rack::Test::Methods
end