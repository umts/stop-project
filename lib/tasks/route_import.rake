require 'csv'

# Example invocation rake 'routes:import[some_csv_file.csv]'

namespace :routes do
  task :import, [:csv_file] => :environment do |_, args|
    Route.delete_all
    BusStopsRoute.delete_all
    @route_hash = {}
    CSV.foreach(args[:csv_file], headers: true, col_sep: ';') do |row|
      stop = BusStop.find_by hastus_id: row['stp_identifier']
      if stop.present?
        route = Route.find_or_create_by number: row['rte_identifier'].strip
        stop.routes << route

        direction = row['direction']
        variant = row['variant']
        stop_id = row['stp_identifier']
        rank = row['stop_variant_rank']

        @route_hash[route] ||= {}
        @route_hash[route][direction] ||= {}
        @route_hash[route][direction][variant] ||= []
        @route_hash[route][direction][variant] << { stop_id => rank }
      end
    end

    @stop_list = []
    @other_variants = []

    @route_hash.each do |route, directions|
      directions.each do |direction, variants|
        # don't want the main variant to have a different direction, set it to nil with each different variant
        @main_variant = nil
        @max_length = 0
        variants.each do |variant, stops|
          if @max_length == 0
            @main_variant = variant
            @max_length = @route_hash[route][direction][@main_variant].length
          elsif @route_hash[route][direction][variant].length > @max_length
            @other_variants << @main_variant
            @max_length = @route_hash[route][direction][variant].length
            @main_variant = variant
          else
            @other_variants << variant
          end
        end
        @route_hash[route][direction][@main_variant].each do |stop_hash|
          stop_hash.each do |hastus_id, rank|
            stop_id = BusStop.find_by(hastus_id: hastus_id).id
            sequence = rank.to_i
            bus_stops_route = BusStopsRoute.create sequence: sequence, bus_stop_id: stop_id, route: route
            route.bus_stops_routes << bus_stops_route
            @stop_list << stop_id
          end
        end
        if @other_variants.present?
          @other_variants.each do |other_variant|
            @route_hash[route][direction][other_variant].each do |stop_hash|
              stop_hash.each do |hastus_id, sequence|
                stop_id = BusStop.find_by(hastus_id: hastus_id).id
                if !@stop_list.include?(stop_id)
                  @max_length = @max_length + 1
                  # might be happening here
                  bus_stops_route = BusStopsRoute.create sequence: @max_length, bus_stop_id: stop_id, route: route
                  route.bus_stops_routes << bus_stops_route
                end
              end
            end
          end
          # remove variants from the array if there were any in there to begin with
          @other_variants = []
        end
      end
    end
  end
end
