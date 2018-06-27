# frozen_string_literal: true

require 'csv'
namespace :bus_stops do
  task export: :environment do
    CSV.open('old_stop_data.csv', 'w', write_headers: true,
             headers: %w[name has_power shared_sign_post system_map_exists trash]) do |csv|
      BusStop.all.each do |stop|
        csv << [stop.name,
                stop.has_power,
                stop.shared_sign_post,
                stop.system_map_exists,
                stop.trash]
      end
    end
  end
end
