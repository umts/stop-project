# frozen_string_literal: true

require 'csv'

namespace :bus_stops do
  task import_data: :environment do
    csv = CSV.parse(File.read('old_stop_data.csv'), headers: true)
    csv.each do |row|
      hash = row.to_hash
      new_attributes = {}
      conversions = { 'has_power' =>
                          (hash['has_power'] == 'true' ? 'Yes - Stub up' : 'No'),
                      'shared_sign_post_frta' =>
                          (hash['shared_sign_post'] == 'Yes - FRTA'),
                      'system_map_exists' =>
                          (hash['system_map_exists'] == 'true' ? 'Old map' : 'No map'),
                      'trash' => (hash['trash'] != 'None') }
      conversions.each do |k, v|
        if k == 'shared_sign_post_frta'
          new_attributes[k] = v unless hash['shared_sign_post'].nil?
        else
          new_attributes[k] = v unless hash[k].nil?
        end
      end
      binding.pry
      stop = BusStop.find_by_id(hash['id'])
      stop.update_attributes(new_attributes)
    end
  end
end
