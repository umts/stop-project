# frozen_string_literal: true

require 'csv'

# Example invocation rake 'routes:import[some_csv_file.csv]'

namespace :routes do
  task :import, [:csv_file] => :environment do |_, args|
    Route.delete_all
    BusStopsRoute.delete_all
    stop_hash = {}
    CSV.foreach(args[:csv_file], headers: true, col_sep: ';') do |row|
      route = row['rte_identifier']
      stop = row['stp_identifier']
      dir = row['direction']
      variant = row['variant']
      sequence = row['stop_variant_rank']

      stop_hash[[route, dir]] ||= {}
      stop_hash[[route, dir]][variant] ||= []
      stop_hash[[route, dir]][variant][sequence] = stop
    end
  end
end
