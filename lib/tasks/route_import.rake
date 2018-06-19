require 'csv'

# Example invocation rake 'routes:import[some_csv_file.csv]'

namespace :routes do
  task :import, [:csv_file] => :environment do |_, args|
    Route.delete_all
    route_hash = {}
    CSV.foreach(args[:csv_file], headers: true, col_sep: ';') do |row|
      stop = BusStop.find_by hastus_id: row['stp_identifier']
      if stop.present?
        route = Route.find_or_create_by number: row['rte_identifier'].strip,
                                        description: row['rte_description']
        stop.routes << route

        direction = row['rte_direction']
        variant = row['variant']
        stop_id = row['stp_identifier']
        rank = row['stop_variant_rank']

        route_hash.merge{ route: route, direction: direction, variant_name: variant, stop_id: stop_id, rank: rank }

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
