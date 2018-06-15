class Field < ApplicationRecord
  self.primary_key = :name

  has_many :bus_stop_fields, foreign_key: :field_name
  has_many :bus_stops, through: :bus_stop_fields
  
  validates :category, presence: true
  validates :rank, presence: true, uniqueness: { scope: :category }
  validates :field_type, inclusion: { in: %i[boolean choice] }
  
  serialize :choices, Array
  validates :choices, presence: true, if: :multiple_choice?
  
  def multiple_choice?
    field_type == :choice
  end
end
