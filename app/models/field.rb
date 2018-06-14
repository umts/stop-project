class Field < ApplicationRecord
  has_many :bus_stop_fields
  has_many :bus_stops, through: :bus_stop_fields

  serialize :choices, Array
end
