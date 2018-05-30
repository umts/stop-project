# frozen_string_literal: true
namespace :stops do
  desc "Mark all stops as incomplete"
  task uncomplete_all: :environment do
    BusStop.update_all completed: false
  end
end
