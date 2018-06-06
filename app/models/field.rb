class Field < ApplicationRecord
  belongs_to :bus_stops, through: :bus_stop_fields
end
