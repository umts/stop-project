# frozen_string_literal: true

namespace :bus_stops do
  task rename: :environment do
    BusStop.all.each do |b|
      b.name += " (#{b.hastus_id})"
      b.save
    end
  end
end
