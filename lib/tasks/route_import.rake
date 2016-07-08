require 'csv'

# Example invocation rake 'routes:import[some_csv_file.csv]'

namespace :routes do
  task :import, [:csv_file] => :environment do |_, args|
    Route.delete_all
    row_num = 1
    CSV.foreach(args[:csv_file], headers: true, col_sep: ';') do |row|
      row_num = row_num + 1
      puts row_num
      stop = BusStop.find_by hastus_id: row['stp_identifier']
      if stop.present?
        route = Route.find_or_create_by number: row['rte_identifier'],
                                        description: row['rte_description']
        stop.routes << route
      else puts "Stop not found: hastus ID #{row['stp_identifier']}"
      end
    end
  end
end
