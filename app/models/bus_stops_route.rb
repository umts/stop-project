# frozen_string_literal: true

class BusStopsRoute < ApplicationRecord
  belongs_to :bus_stop
  belongs_to :route

  validates :sequence, presence: true,
                       numericality: { greater_than_or_equal_to: 1 }
  validates :direction, presence: true
  validates_uniqueness_of :sequence, scope: %i[route direction]
  validates_uniqueness_of :bus_stop, scope: %i[route direction]
  
  # This method is used for importing a csv of routes. The input stop_hash
  # has a route and direction array pointing to trips with stops (ordered
  # by sequence). import combines all stops per route direction, and
  # sequences those stops accordingly.
  def self.import(stop_hash)
    # The route direction array key isn't used because it doesn't matter here.
    # Since stop_hash is used for creating routes and bus_stops_routes, though,
    # we need to keep those keys.
    stop_hash.each_pair do |route_dir, direction_trips|
      trips = direction_trips.values.uniq.map(&:compact).map(&:uniq)
      longest_trip = trips.max_by(&:length)
      other_trips = trips - [longest_trip]
      other_trips.each do |trip|
        trip.each.with_index do |stop, sequence|
          unless longest_trip.include? stop
            # We can't rely on the previous stop here
            # like we do in the corresponding else statement.
            if stop == trip.first
              # first stop on longest trip that's on the other trip
              first_shared_stop = longest_trip.find do |known_stop|
                trip.include? known_stop
              end
              if first_shared_stop.present?
                # insert stop before first known stop on longest trip
                first_shared_stop_index = longest_trip.index(first_shared_stop)
                longest_trip.insert(first_shared_stop_index, stop)
              # the other trip has no stops in common with the longest trip
              else
                # add the stop onto the end of the longest trip
                longest_trip << stop
              end
            else
              # the previous stop will already be in the longest trip
              previous_stop = trip[sequence - 1]
              previous_stop_index_in_longest_trip = longest_trip.index(previous_stop)
              # Array#insert inserts before the given index.
              longest_trip.insert(previous_stop_index_in_longest_trip + 1, stop)
            end
          end
        end
      end
      # condenses all trip and stop data into one array of stop ids,
      # representing the ordered path of all possible stops on that
      # route in one particular direction.
      stop_hash[route_dir] = longest_trip
    end
  end
end
