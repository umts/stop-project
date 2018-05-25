# frozen_string_literal: true

desc "Mark all stops as incomplete"
task :all_incomplete do
  BusStop.update_all completed: false
end
