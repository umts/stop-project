# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails'
SimpleCov.start do
  add_filter '/config/'
  add_filter '/spec/'
  refuse_coverage_drop if ENV['CI']
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'devise'
require 'factory_bot_rails'

ActiveRecord::Migration.maintain_test_schema!
Capybara.default_driver = :selenium
RSpec.configure do |config|
  config.order = :random
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.before :all do
    FactoryBot.reload
  end
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
