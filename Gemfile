# frozen_string_literal: true

source 'https://rubygems.org'
ruby IO.read(File.expand_path('.ruby-version', __dir__)).strip

gem 'bootstrap-sass'
gem 'devise', '~> 4.6'
gem 'haml-rails'
gem 'jquery-rails', '~> 4.3'
gem 'jquery-ui-rails', '~> 6.0'
gem 'mysql2', '~> 0.4'
gem 'paper_trail', '~> 11.1'
gem 'rails', '~> 6.1.3'
gem 'sassc-rails'
gem 'underscore-rails', '~> 1.8'
gem 'will_paginate', '~> 3.1'

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
  gem 'simplecov'
  gem 'webdrivers'
end
