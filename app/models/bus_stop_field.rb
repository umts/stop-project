class BusStopField < ApplicationRecord
  belongs_to :bus_stops, foreign_key: :bus_stop_id
  belongs_to :fields, primary_key: :names
end
