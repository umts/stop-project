class User < ApplicationRecord
  devise :database_authenticatable, :validatable
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  has_many :stops_completed, class_name: 'BusStop', foreign_key: 'completed_by'

  # :nocov:
  def self.dev_login_options
    order(:name).group_by { |u| u.admin? ? 'Admins' : 'Non-Admins' }.transform_values do |users|
      users.map { |u| [u.name, u.id] }
    end
  end
  # :nocov:
end
