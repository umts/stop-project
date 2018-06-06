class Field < ApplicationRecord
  has_many :bus_stop_fields
  has_and_belongs_to_many :bus_stops, through: :bus_stop_fields
end
