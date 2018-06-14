class Field < ApplicationRecord
  self.primary_key = :name

  has_many :bus_stop_fields, foreign_key: :field_name
  has_many :bus_stops, through: :bus_stop_fields

  serialize :choices, Array
end
