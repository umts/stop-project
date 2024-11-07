# frozen_string_literal: true

source 'https://rubygems.org'
ruby file: '.ruby-version'

gem 'bootstrap', '~> 5.3'
gem 'devise', '~> 4.9'
gem 'haml-rails'
gem 'importmap-rails'
gem 'irb'
gem 'kaminari'
gem 'mysql2'
gem 'paper_trail', '~> 12.3'
gem 'rails', '~> 7.0.8'
gem 'sassc-rails'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'strong_password'
gem 'turbo-rails'

group :production do
  gem 'exception_notification'
  gem 'uglifier'
end

group :development do
  gem 'bcrypt_pbkdf', require: false
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-pending', require: false
  gem 'capistrano-rails', require: false
  gem 'ed25519', require: false
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
  gem 'timecop'
end

group :test do
  gem 'capybara'
  gem 'puma'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'simplecov'
end
