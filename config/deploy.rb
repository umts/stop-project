# frozen_string_literal: true

lock '~> 3.14'

set :application, 'stop-project'
set :repo_url, 'https://github.com/umts/stop-project.git'
set :branch, :master
set :deploy_to, "/srv/#{fetch :application}"

set :log_level, :info

append :linked_files, 'config/database.yml'
append :linked_dirs, '.bundle', 'log'

set :passenger_restart_with_sudo, true
