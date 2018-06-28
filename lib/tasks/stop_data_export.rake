# frozen_string_literal: true

require 'csv'

namespace :bus_stops do
  task export_old_data: :environment do
    CSV.open('old_stop_data.csv', 'w') do |csv|
      headers = %w[id has_power shared_sign_post system_map_exists trash]
      csv << headers
      BusStop.all.each do |stop|
        csv << [stop.id,
                stop.has_power,
                stop.shared_sign_post,
                stop.system_map_exists,
                stop.trash]
      end
    end
  end
end
