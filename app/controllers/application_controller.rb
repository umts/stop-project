class ApplicationController < ActionController::Base
  include DateAndTimeMethods

  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit

  private

  def restrict_to_admin
    head :unauthorized and return unless current_user.admin?
  end
end
