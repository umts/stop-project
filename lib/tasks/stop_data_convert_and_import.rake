# frozen_string_literal: true

require 'csv'
namespace :bus_stops do
  task :import_data, [:csv_file] => :environment do |_, args|
    csv = CSV.parse(File.read(args[:csv_file]), headers: true)
    csv.each do |row|
      hash = row.to_hash
      hash['trash'] = (hash['trash'] != 'None')
      hash['has_power'] = (hash['has_power'] == 'true' ? 'Yes - Stub up' : 'No')
      hash['shared_sign_post'] = (hash['shared_sign_post'] == 'Yes - FRTA')
      hash['shared_sign_post_frta'] = hash.delete('shared_sign_post')
      hash['system_map_exists'] = (hash['system_map_exists'] == 'true' ? 'Old map' : 'No map')
      stop = BusStop.find_by_name(hash['name'])
      stop.update_attributes(hash)
    end
  end
end
