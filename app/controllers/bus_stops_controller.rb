class BusStopsController < ApplicationController
  before_action :find_stop, only: %i(edit)

  def edit
  end

  def index
    @stops = BusStop.all
  end

  private

  def find_stop
    @stop = BusStop.find_by id: params.require(:id)
    unless @stop.present?
      render nothing: true, status: :not_found and return
    end
  end
end
