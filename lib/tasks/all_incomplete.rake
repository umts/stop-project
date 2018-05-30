# frozen_string_literal: true
namespace :update_all_stops do
  desc "Mark all stops as incomplete"
  task all_incomplete: :environment do
    BusStop.update_all completed: false
  end
end
