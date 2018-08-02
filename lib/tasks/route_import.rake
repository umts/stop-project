# frozen_string_literal: true

require 'csv'

# Example invocation rake 'routes:import[some_csv_file.csv]'

namespace :routes do
  task :import, [:csv_file] => :environment do |_, args|
    Route.delete_all
    CSV.foreach(args[:csv_file], headers: true, col_sep: ';') do |row|
      route_number = row['route_id']
      Route.find_or_create_by! number: route_number.strip
    end
  end
end
