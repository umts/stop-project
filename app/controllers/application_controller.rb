class ApplicationController < ActionController::Base
  include DateAndTimeMethods

  protect_from_forgery with: :exception, prepend: true
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit

  helper_method :format_datetime
  
  private

  def restrict_to_admin
    head :unauthorized and return unless current_user.admin?
  end
end
