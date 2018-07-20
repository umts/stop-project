class ApplicationController < ActionController::Base
  include DateAndTimeMethods

  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit
  before_action :prepare_exception_notifier

  helper_method :format_datetime

  private

  def prepare_exception_notifier
    if request.env['exception_notifier.exception_data'].nil?
      request.env['exception_notifier.exception_data'] = {
        current_user: current_user
      }
    else
      request.env['exception_notifier.exception_data']
             .merge(current_user: current_user)
    end
  end
  
  def restrict_to_admin
    head :unauthorized and return unless current_user.admin?
  end
end
