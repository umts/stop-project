# frozen_string_literal: true

require 'csv'

# Example invocation rake 'routes:import[some_csv_file.csv]'

namespace :routes do
  task :import, [:csv_file] => :environment do |_, args|
    stop_hash = {}
    CSV.foreach(args[:csv_file], headers: true, col_sep: ';') do |row|
      route = row['rte_identifier']
      stop = row['stp_identifier']
      dir = row['direction']
      variant = row['variant']
      sequence = row['stop_variant_rank'].to_i

      stop_hash[[route, dir]] ||= {}
      stop_hash[[route, dir]][variant] ||= []
      stop_hash[[route, dir]][variant][sequence] = stop
    end
    BusStopsRoute.import(stop_hash)
    
    Route.delete_all
    BusStopsRoute.delete_all
    
    stop_hash.each_pair do |(route, direction), stops|
      Route.find_or_create_by! number: route.strip
      stops.each.with_index_1 do |stop, sequence|
        BusStopsRoute.create!(route: route, direction: direction, stop: stop, sequence: sequence)
      end
    end
  end
end
