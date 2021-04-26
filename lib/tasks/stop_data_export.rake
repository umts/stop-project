# frozen_string_literal: true

require 'csv'

namespace :bus_stops do
  task export_old_data: :environment do
    CSV.open('old_stop_data.csv', 'w', write_headers: true,
                                       headers: %w[id has_power shared_sign_post system_map_exists trash]) do |csv|
      BusStop.all.each do |stop|
        csv << [stop.id,
                stop.has_power,
                stop.shared_sign_post,
                stop.system_map_exists,
                stop.trash]
      end
    end
  end
  task export_modern_shelter_data: :environment do
    attributes = BusStop.attribute_names
    CSV.open('all_stop_data.csv', 'w', write_headers: true, headers: attributes) do |csv|
      BusStop.all.each do |stop|
        csv << attributes.map { |attr| stop.send(attr) }
      end
    end
  end
end
