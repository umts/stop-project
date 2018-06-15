class User < ApplicationRecord
  devise :database_authenticatable
  validates :name, :email, presence: true, uniqueness: true
  validate :confirmation_matches, if: -> { password.present? }
  has_many :stops_completed, class_name: 'BusStop', foreign_key: 'completed_by'

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
