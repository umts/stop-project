require 'csv'

# Example invocation rake 'routes:import[some_csv_file.csv]'

namespace :routes do
  task :import, [:csv_file] => :environment do |_, args|
    Route.delete_all
    CSV.foreach(args[:csv_file], headers: true, col_sep: ';') do |row|
      stop = BusStop.find_by hastus_id: row['stp_identifier']
      if stop.present?
        route_hash = {}
        stop_ids = []

        # what I want looks like:
        # { route: G2, direction: 'South', variants: { M_south => [], M_north => [], Main_S => [] } }
        
        route = Route.find_or_create_by number: row['rte_identifier'].strip,
                                        description: row['rte_description']
        stop.routes << route


        variant = row['variant']
        direction = row['rte_direction']
        rank = row['stop_variant_rank']
        stop_id = row['stp_identifier']
        stop_ids[rank-1] = stop_id #index starting at 0

        route_hash.merge{ route: route, direction: direction, variant_name: variant, stop_ids: stop_ids }
        # hopefully this isn't overwritten...

      end
      route_hash.each do |route|
      # per direction
        route.each_pair do |direction, variants|
        # find variant with max stops
          # look at other variants
          # if any other stops are still in the route
              variants
              # rank according to the other variant and place after the first variant
              # (the rank will be saved as the sequence number)
        end
      end
    end
  end
end
