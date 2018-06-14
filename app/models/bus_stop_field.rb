class BusStopField < ApplicationRecord
  belongs_to :bus_stop
  belongs_to :field, primary_key: :name, foreign_key: :field_name
end
