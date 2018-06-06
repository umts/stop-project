class Field < ApplicationRecord
  belongs_to_many :bus_stops, through :bus_stop_fields
end
