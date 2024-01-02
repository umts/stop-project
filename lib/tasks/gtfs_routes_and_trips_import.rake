# frozen_string_literal: true

require 'csv'

namespace :gtfs_routes_and_trips do
  desc 'Import GTFS routes.txt and trips.txt'
  task import: :environment do
    route_data = {}
    stop_data = {}
    missing_trips = []

    Route.delete_all

    CSV.foreach('routes.txt', headers: true) do |row|
      route_id = row['route_id']
      number = row['route_short_name']
      description = row['route_long_name']
      route = Route.find_or_create_by!(number:)
      route.update!(description:)
      route_data[route_id] = number
    end

    CSV.foreach('trips.txt', headers: true) do |row|
      route_id = row['route_id']
      direction = row['direction_id']
      trip_id = row['trip_id']
      route_number = route_data[route_id]
      stop_data[[route_number, direction]] ||= {}
      stop_data[[route_number, direction]][trip_id] ||= []
    end

    CSV.foreach('stop_times.txt', headers: true) do |row|
      trip_id = row['trip_id']
      sequence = row['stop_sequence'].to_i
      stop_id = row['stop_id']

      route = stop_data.values.find do |trips|
        trips.keys.include? trip_id
      end
      if route.nil?
        missing_trips << trip_id
      else
        route[trip_id][sequence] = stop_id
      end
    end

    BusStopsRoute.establish_sequences(stop_data)

    BusStopsRoute.delete_all

    stop_data.each_pair do |(route_number, direction), stop_ids|
      route = Route.find_or_create_by! number: route_number.strip
      stop_ids.each.with_index(1) do |stop_id, sequence|
        stop = BusStop.find_by(hastus_id: stop_id)
        BusStopsRoute.create!(bus_stop: stop, route:, direction:, sequence:) if stop.present?
      end
    end
    puts "The following trips were missing from trips.txt: #{missing_trips.join(', ')}" if missing_trips.present?
  end
end
