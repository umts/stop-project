class BusStopsRoute < ApplicationRecord
  belongs_to :bus_stop
  belongs_to :route
end
