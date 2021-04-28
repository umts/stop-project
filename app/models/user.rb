class User < ApplicationRecord
  devise :database_authenticatable
  validates :name, :email, presence: true, uniqueness: { case_sensitive: false }
  validate :confirmation_matches, if: -> { password.present? }
  has_many :stops_completed, class_name: 'BusStop', foreign_key: 'completed_by'

  # :nocov:
  def self.dev_login_options
    order(:name).group_by { |u| u.admin? ? 'Admins' : 'Non-Admins' }.transform_values do |users|
      users.map { |u| [u.name, u.id] }
    end
  end
  # :nocov:

  def not_admin?
    !admin?
  end

  private

  def confirmation_matches
    if password != password_confirmation
      errors.add :password_confirmation, 'does not match password'
    end
  end
end
