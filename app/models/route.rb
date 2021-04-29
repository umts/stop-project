# frozen_string_literal: true

class Route < ApplicationRecord
  validates :number, presence: true, uniqueness: { case_sensitive: false }
  has_many :bus_stops_routes
  has_many :bus_stops, through: :bus_stops_routes
  default_scope { order :number }

  def stops_by_sequence(direction)
    bus_stops.where(bus_stops_routes: { direction: direction })
             .order('sequence')
  end

  def next_stop_in_sequence(stop, direction)
    stops = stops_by_sequence(direction)
    next_stop_index = stops.find_index(stop) + 1
    stops[next_stop_index]
  end
end
