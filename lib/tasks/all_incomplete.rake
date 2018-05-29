# frozen_string_literal: true
namespace :all_incomplete do
  desc "Mark all stops as incomplete"
  task :all_incomplete do
    BusStop.update_all completed: false
  end
end
