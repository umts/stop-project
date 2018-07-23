# frozen_string_literal: true

require 'csv'

namespace :bus_stops_route do
  task :import => :environment do
    stop_hash = {}
    missing_trips = []

    CSV.foreach('trips.txt', headers: true) do |row|
      route_number = row['route_id']
      direction = row['direction_id']
      trip_id = row['trip_id']
      unless route_number.blank? 
        stop_hash[[route_number, direction]] ||= {}
        stop_hash[[route_number, direction]][trip_id] ||= []
      end
    end

    CSV.foreach('stop_times.txt', headers: true) do |row|
      trip_id = row['trip_id']
      sequence = row['stop_sequence'].to_i
      stop_id = row['stop_id']

      route = stop_hash.select do |route_direction, trips|
        trips.keys.include? trip_id
      end
      if route.empty?
        missing_trips << trip_id
      else
        route.values.first[trip_id][sequence] = stop_id
      end
    end

    BusStopsRoute.import(stop_hash)
    
    BusStopsRoute.delete_all

    
    stop_hash.each_pair do |(route_number, direction), stop_ids|
      route = Route.find_or_create_by! number: route_number.strip
      stop_ids.each.with_index(1) do |stop_id, sequence|
        stop = BusStop.find_by(hastus_id: stop_id)
        if stop.present?
          BusStopsRoute.create!(
            route: route, direction: direction, bus_stop: stop, sequence: sequence
          )
        end
      end
    end
    puts "The following trips were missing from trips.txt: #{missing_trips.join(', ')}"
  end
end
