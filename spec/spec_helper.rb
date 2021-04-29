# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails' do
  refuse_coverage_drop if ENV['CI']
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'devise'
require 'factory_bot_rails'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.order = :random
  Kernel.srand config.seed

  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include CurrentUserHelpers

  config.before :all do
    FactoryBot.reload
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.disable_monkey_patching!

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.filter_run_when_matching :focus
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.example_status_persistence_file_path = 'spec/examples.txt'

  config.before :each, type: :system do
    driven_by :rack_test
  end

  config.before :each, type: :system, js: true do
    driven_by :selenium, using: :headless_chrome
  end
end
