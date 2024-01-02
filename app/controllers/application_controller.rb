# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit
  before_action :prepare_exception_notifier

  private

  def prepare_exception_notifier
    request.env['exception_notifier.exception_data'] ||= {}
    request.env['exception_notifier.exception_data'].merge(current_user:)
  end

  def restrict_to_admin
    head :unauthorized and return unless current_user.admin?
  end
end
