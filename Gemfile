# frozen_string_literal: true

source 'https://rubygems.org'
ruby file: '.ruby-version'

gem 'bootstrap', '~> 5.3'
gem 'csv'
gem 'devise', '~> 4.9'
gem 'gtfs'
gem 'haml-rails'
gem 'importmap-rails'
gem 'irb'
gem 'kaminari'
gem 'mysql2'
# TODO: remove when we have modern glibc
gem 'nokogiri', force_ruby_platform: true
gem 'paper_trail'
gem 'rails', '~> 8.0.4'
gem 'sassc-rails'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'strong_password'
gem 'turbo-rails'

group :production do
  gem 'exception_notification'
  gem 'rack-attack'
  gem 'uglifier'
end

group :development do
  gem 'bcrypt_pbkdf', require: false
  gem 'brakeman', require: false
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-pending', require: false
  gem 'capistrano-rails', require: false
  gem 'ed25519', require: false
  gem 'haml_lint', require: false
  gem 'overcommit', require: false
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false
  gem 'spring'
end

group :development, :test do
  gem 'debug'
  gem 'factory_bot_rails'
  gem 'listen'
end

group :test do
  gem 'capybara'
  gem 'puma'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'simplecov'
end
