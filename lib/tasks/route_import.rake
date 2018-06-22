# frozen_string_literal: true

require 'csv'

# Example invocation rake 'routes:import[some_csv_file.csv]'

namespace :routes do
  task :import, [:csv_file] => :environment do |_, args|
    Route.delete_all
    BusStopsRoute.delete_all
    route_hash = {}
    CSV.foreach(args[:csv_file], headers: true, col_sep: ';') do |row|
      stop = BusStop.find_by hastus_id: row['stp_identifier']
      if stop.present?
        route = Route.find_or_create_by number: row['rte_identifier'].strip

        direction = row['direction']
        variant = row['variant']
        stop_id = row['stp_identifier']
        sequence = row['stop_variant_rank']

        route_hash[route] ||= {}
        route_hash[route][direction] ||= {}
        route_hash[route][direction][variant] ||= []
        route_hash[route][direction][variant] << { stop_id => sequence }
      end
    end

    route_hash.each do |route, directions|
      directions.each do |direction, variants|
        sequences = []
        stop_list = []

        # sort the variants by the length of their stops, longest variant first
        sorted_variants = variants.sort_by do |_variant, stops|
          stops.length
        end.reverse!

        sorted_variants.each do |variant, stops|
          stops.each do |stop_hash|
            stop_hash.each do |hastus_id, rank|
              sequence = rank.to_i
              stop = BusStop.find_by hastus_id: hastus_id
              next if stop_list.include? stop
              stop_list << stop
              if sequences.include? sequence
                sequence = sequences.last + 1
              end
              sequences << sequence
              BusStopsRoute.create!(
                bus_stop: stop, route: route, direction: direction, sequence: sequence 
              )
            end
          end
        end
      end
    end
  end
end
