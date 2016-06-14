class ApplicationController < ActionController::Base
  include DateAndTimeMethods

  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit
end
