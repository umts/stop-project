class Route < ApplicationRecord
  validates :number, presence: true, uniqueness: true
  validates :description, presence: true
  has_many :bus_stops, through: :bus_stops_routes
  default_scope { order :number }
end
