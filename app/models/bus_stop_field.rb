class BusStopField < ApplicationRecord
  belongs_to :bus_stop
  belongs_to :field, foreign_key: :field_name
end
