source 'https://rubygems.org'
ruby IO.read(File.expand_path('.ruby-version', __dir__)).strip

gem 'bootstrap-sass'
gem 'devise', '~> 4.6'
gem 'haml-rails', '~> 1.0'
gem 'jquery-rails', '~> 4.3'
gem 'jquery-ui-rails', '~> 6.0'
gem 'mysql2', '~> 0.4'
gem 'paper_trail', '~> 9.2'
gem 'rails', '~> 5.1'
gem 'sassc-rails'
gem 'spring'
gem 'underscore-rails', '~> 1.8'
gem 'will_paginate', '~> 3.1'

group :production do
  gem 'exception_notification', '~> 4.2'
  gem 'uglifier'
end

group :development do
  gem 'capistrano', '~> 3.14.1', require: false
  gem 'capistrano-pending', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-passenger', require: false
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'timecop', '~> 0.9.1'
end

group :test do
  gem 'capybara', '~> 3.18'
  gem 'puma', '~> 3.12'
  gem 'rspec-rails', '~> 3.7'
  gem 'selenium-webdriver', '~> 3.8'
  gem 'simplecov'
  gem 'webdrivers'
end

gem "listen", "~> 3.2"
