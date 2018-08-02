class Route < ApplicationRecord
  validates :number, presence: true, uniqueness: true
  has_many :bus_stops_routes
  has_many :bus_stops, through: :bus_stops_routes
  default_scope { order :number }

  def stops_by_sequence(route_id, direction)
    BusStop
      .joins(:bus_stops_routes)
      .where(bus_stops_routes: { route_id: route_id, direction: direction })
      .order('sequence')
  end

  def next_stop_in_sequence(stop, route_id, direction)
    stops = stops_by_sequence(route_id, direction)
    index = stops.find_index(stop) + 1
    stops[index]
  end
end
