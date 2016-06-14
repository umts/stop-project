class Route < ActiveRecord::Base
  validates :number, presence: true, uniqueness: true
  has_and_belongs_to_many :bus_stops
  default_scope { order :number }
end
