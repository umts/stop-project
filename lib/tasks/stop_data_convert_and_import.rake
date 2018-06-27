# frozen_string_literal: true

require 'csv'
namespace :bus_stops do
  task :import_data, [:csv_file] => :environment do |_, args|
    csv = CSV.parse(File.read(args[:csv_file]), headers: true)
    csv.each do |row|
      hash = row.to_hash
      stop = BusStop.find_by_name(hash['name'])
      stop.update_attributes(hash)
    end
  end
end
