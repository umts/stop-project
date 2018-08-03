# frozen_string_literal: true

require 'csv'

# Example invocation rake 'routes:import[some_csv_file.csv]'

namespace :routes do
  task :import, [:csv_file] => :environment do |_, args|
    Route.delete_all
    CSV.foreach(args[:csv_file], headers: true) do |row|
      number = row['route_short_name']
      description = row['route_long_name']
      route = Route.find_or_create_by! number: number
      route.update! description: description
    end
  end
end
