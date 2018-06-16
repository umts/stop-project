class Field < ApplicationRecord
  self.primary_key = :name

  has_many :bus_stop_fields, foreign_key: :field_name
  has_many :bus_stops, through: :bus_stop_fields
  
  validates :category, presence: true
  validates :rank, presence: true, uniqueness: { scope: :category }
  validates :field_type, inclusion: { in: %w[boolean choice] }
  
  serialize :choices, Array
  validates :choices, presence: true, if: :multiple_choice?

  scope :in_category, ->(category) { where category: category }

  def multiple_choice?
    field_type == :choice
  end

  def self.categories
    order(:category).pluck(:category).uniq
  end
end
