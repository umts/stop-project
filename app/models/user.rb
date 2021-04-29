class User < ApplicationRecord
  devise :database_authenticatable, :validatable
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  has_many :stops_completed, class_name: 'BusStop', foreign_key: 'completed_by'
end
