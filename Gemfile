# frozen_string_literal: true

source 'https://rubygems.org'
ruby file: '.ruby-version'

gem 'bootstrap', '~> 5.3'
gem 'devise', '~> 4.6'
gem 'haml-rails'
gem 'importmap-rails'
gem 'kaminari'
gem 'mysql2', '~> 0.4'
gem 'paper_trail', '~> 12.3'
gem 'rails', '~> 7.0.8'
gem 'sassc-rails'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'strong_password'
gem 'turbo-rails'

group :production do
  gem 'exception_notification', '~> 4.2'
  gem 'uglifier'
end

group :development do
  gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0', require: false
  gem 'capistrano', '~> 3.14', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-pending', require: false
  gem 'capistrano-rails', require: false
  gem 'ed25519', '>= 1.2', '< 2.0', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring'
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'listen'
  gem 'pry-byebug'
  gem 'timecop'
end

group :test do
  gem 'capybara'
  gem 'puma'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'simplecov'
end
