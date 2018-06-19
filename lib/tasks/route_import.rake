require 'csv'

# Example invocation rake 'routes:import[some_csv_file.csv]'

namespace :routes do
  task :import, [:csv_file] => :environment do |_, args|
    Route.delete_all
    CSV.foreach(args[:csv_file], headers: true, col_sep: ';') do |row|
      stop = BusStop.find_by hastus_id: row['stp_identifier']
      variant = row['variant']
      direction = row['direction']
      stop_variant_rank = row['stop_variant_rank']
      if stop.present?
        route = Route.find_or_create_by number: row['rte_identifier'].strip,
                                        description: row['rte_description']
        # find variant with max stops
        #   look at other variants
        #     if any other stops are still in the route
        #       rank according to the other variant and place after the first variant
        #       (the rank will be saved as the sequence number)

        stop.routes << route
      end
    end
  end
end
