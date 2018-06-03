source 'https://rubygems.org'

gem 'bootstrap-sass'
gem 'coffee-rails', '~> 4.2'
gem 'devise', '~> 4.4'
gem 'haml-rails', '~> 1.0'
gem 'jquery-rails', '~> 4.3'
gem 'jquery-ui-rails', '~> 6.0'
gem 'mysql2', '~> 0.4'
gem 'paper_trail', '~> 8.1'
gem 'rails', '~> 5.1'
gem 'sass-rails', '~> 5.0'
gem 'underscore-rails', '~> 1.8'
gem 'will_paginate', '~> 3.1'

group :production do
  gem 'exception_notification', '~> 4.2'
end

group :development do
  gem 'capistrano', '=3.8.1', require: false
  gem 'capistrano-pending', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-passenger', require: false
  gem 'timecop', '~> 0.9.1'
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'pry-byebug'
end

group :test do
  gem 'capybara', '~> 2.16'
  gem 'chromedriver-helper', '~> 1.1'
  gem 'puma', '~> 3.7'
  gem 'rspec-rails', '~> 3.7'
  gem 'selenium-webdriver', '~> 3.8'
  gem 'simplecov'
end
