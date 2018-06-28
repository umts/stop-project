# frozen_string_literal: true

require 'csv'

namespace :bus_stops do
  task import_old_data: :environment do
    csv = CSV.parse(File.read('old_stop_data.csv'), headers: true)
    csv.each do |row|
      import_data = row.to_hash
      new_attributes = {}
      conversion_methods = { 'has_power' =>
                                 (import_data['has_power'] == 'true' ? 'Yes - Stub up' : 'No'),
                             'shared_sign_post_frta' =>
                                 (import_data['shared_sign_post'] == 'Yes - FRTA'),
                             'system_map_exists' =>
                                 (import_data['system_map_exists'] == 'true' ? 'Old map' : 'No map'),
                             'trash' => (import_data['trash'] != 'None') }
      conversion_methods.each do |attribute, conversion|
        if attribute == 'shared_sign_post_frta'
          new_attributes[attribute] = conversion unless import_data['shared_sign_post'].nil?
        else
          new_attributes[attribute] = conversion unless import_data[attribute].nil?
        end
      end
      stop = BusStop.find_by_id(import_data['id'])
      stop.update_attributes(new_attributes)
    end
  end
end
