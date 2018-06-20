class BusStopsRoute < ApplicationRecord
  belongs_to :bus_stop
  belongs_to :route

  validates :sequence, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
