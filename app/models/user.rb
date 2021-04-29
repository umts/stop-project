# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable
  validates :name, :email, presence: true, uniqueness: { case_sensitive: false }
  validate :confirmation_matches, if: -> { password.present? }
  has_many :stops_completed, class_name: 'BusStop', foreign_key: 'completed_by'

  private

  def confirmation_matches
    return unless password != password_confirmation

    errors.add :password_confirmation, 'does not match password'
  end
end
