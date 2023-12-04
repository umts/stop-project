# frozen_string_literal: true

namespace :bus_stops do
  desc 'Fix invalid stops by deeming them incomplete'
  task fix_invalid_via_incomplete: :environment do
    power = BusStop.completed.where(has_power: nil)
    sys_map = BusStop.completed.where(system_map_exists: nil)
    frta = BusStop.completed.where(shared_sign_post_frta: nil)
    trash = BusStop.completed.where(trash: nil)

    power.or(sys_map).or(frta).or(trash).find_each do |stop|
      stop.update! completed: false
    end
  end

  desc 'Fix invalid stops by assuming they have none of the missing things'
  task fix_invalid_via_stop_features: :environment do
    power = BusStop.completed.where(has_power: nil)
    sys_map = BusStop.completed.where(system_map_exists: nil)
    frta = BusStop.completed.where(shared_sign_post_frta: nil)
    trash = BusStop.completed.where(trash: nil)

    power.or(sys_map).or(frta).or(trash).find_each do |stop|
      stop.update! has_power: 'No', system_map_exists: 'No map',
                   trash: false, shared_sign_post_frta: false
    end
  end
end
