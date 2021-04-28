class User < ApplicationRecord
  devise :database_authenticatable, :validatable

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :password, password_strength: true, if: :password_required?

  has_many :stops_completed, class_name: 'BusStop', foreign_key: 'completed_by'

  def not_admin?
    !admin?
  end
end
