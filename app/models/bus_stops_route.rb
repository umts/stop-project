class BusStopsRoute < ApplicationRecord
  belongs_to :bus_stop
  belongs_to :route

  validates :sequence, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :direction, presence: true
  validates_uniqueness_of :sequence, scope: [ :route, :direction ]
  validates_uniqueness_of :bus_stop, scope: [ :route, :direction ]
end
