require 'csv'

# Example invocation rake 'routes:import[some_csv_file.csv]'

namespace :routes do
  task :import, [:csv_file] => :environment do |_, args|
    Route.delete_all
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
    @max_length = 0

    # per route
    @route_hash.keys.each do |route|
    # per direction
      @route_hash[route].keys.each do |direction|
        @route_hash[route][direction].keys.each do |variant|
          if @max_length == 0
            @main_variant = variant
            @max_length = @route_hash[route][direction][@main_variant].length
          end
          if @route_hash[route][direction][variant].length > @max_length
            @other_variants << @main_variant
            # find variant with max stops
            @max_length = @route_hash[route][direction][variant].length
            @main_variant = variant
          else
            @other_variants << variant
          end
          @route_hash[route][direction][@main_variant] do |stop_id, sequence|
            binding.pry
            stop = BusStop.find_by id: stop_id

            bus_stops_route = BusStopsRoute.create sequence: sequence, bus_stop: stop, route: route
            route.bus_stops_routes << bus_stops_route

            @stop_list << stop_id
            @length = sequence
          end
        # look at other variants
          if @other_variants.present?
            # figure out if any other stops are still in the route
            @other_variants.each do |variant|
              @route_hash[route][direction][variant].each do |stop_id, _|
                if !@stop_list.include(stop_id)
                  stop = BusStop.find_by id: stop_id
                  bus_stops_route = BusStopsRoute.create sequence: @length = @length + 1, bus_stop: stop, route: route
                  route.bus_stops_routes << bus_stops_route
                end
              end 
            end
          end
        end
      end
    end
  end
end
