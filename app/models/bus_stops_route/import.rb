# frozen_string_literal: true

class BusStopsRoute < ApplicationRecord
  class Import
    def initialize(source)
      @source = source
    end

    def combined_trip_data
      trip_data.transform_values do |trips|
        trips.max_by(&:length).tap do |longest_sequence|
          trips.excluding(longest_sequence).each do |sequence|
            ([nil] + sequence).each_cons(2) do |previous_stop_id, stop_id|
              next if longest_sequence.include? stop_id

              # after the previous stop in this sequence...
              location_in_longest_sequence = longest_sequence.index(previous_stop_id) ||
                                             # ...or before the first common stop, or, failing all that, at the end
                                             (common_index(longest_sequence, sequence) - 1)

              longest_sequence.insert(location_in_longest_sequence + 1, stop_id)
            end
          end
        end
      end
    end

    def import!
      combined_trip_data.each do |(route_name, direction), stops|
        route = Route.find_by!(number: route_name)

        BusStopsRoute.transaction do
          route.bus_stops_routes.where(direction: direction).delete_all
          stops.each.with_index(1) do |stop_id, sequence|
            bus_stop = BusStop.find_by! hastus_id: stop_id
            route.bus_stops_routes.create! bus_stop:, direction:, sequence:
          end
        end
      end
    end

    private

    def common_index(main, other)
      main.index((main & other).first) || -1
    end

    def grouped_trips
      @grouped_trips ||= @source.trips.group_by do |trip|
        [route_name(trip.route_id), trip.direction_id]
      end
    end

    def route_name(route_id)
      @route_names ||= @source.routes.to_h { |route| [route.id, route.short_name] }
      @route_names[route_id]
    end

    def stop_sequence(trip)
      [].tap do |sequence|
        stops_by_trip[trip.id].each do |stop_time|
          sequence[stop_time.stop_sequence.to_i - 1] = stop_time.stop_id
        end
      end.compact
    end

    def stops_by_trip
      @stops_by_trip ||= @source.stop_times.group_by(&:trip_id)
    end

    def trip_data
      @trip_data ||= grouped_trips.transform_values do |trips|
        trips.map { |trip| stop_sequence(trip) }.uniq
      end
    end
  end
end
