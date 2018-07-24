# frozen_string_literal: true

require 'csv'

namespace :bus_stops do
  task import_old_data: :environment do
    csv = CSV.read('old_stop_data.csv', headers: true)
    csv.each do |row|
      new_attributes = {}
      new_attributes['has_power'] = case row['has_power']
                                    when 'true' then 'Yes - Stub up'
                                    when 'false' then 'No'
                                    end
      new_attributes['shared_sign_post_frta'] = case row['shared_sign_post']
                                                when nil then nil
                                                when 'Yes - FRTA' then true
                                                else false
                                                end
      new_attributes['system_map_exists'] = case row['system_map_exists']
                                            when 'true' then 'Old map'
                                            when 'false' then 'No map'
                                            end
      new_attributes['trash'] = case row['trash']
                                when nil then nil
                                when 'None' then false
                                else true
                                end
      stop = BusStop.find row['id']
      stop.update_attributes(new_attributes)
    end
  end
end
