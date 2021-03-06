# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :validatable

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :password, password_strength: true, if: :password_required?

  has_many :stops_completed, class_name: 'BusStop', foreign_key: 'completed_by',
                             inverse_of: :completed_by, dependent: :nullify

  # :nocov:
  def self.dev_login_options
    order(:name).group_by { |u| u.admin? ? 'Admins' : 'Non-Admins' }.transform_values do |users|
      users.map { |u| [u.name, u.id] }
    end
  end
  # :nocov:
end
