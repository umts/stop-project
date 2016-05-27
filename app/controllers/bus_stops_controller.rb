class BusStopsController < ApplicationController
  before_action :find_stop, only: %i(edit update)

  def edit
  end

  def index
    @stops = BusStop.all
  end

  def update
    if @stop.update stop_params
      flash[:notice] = 'Bus stop was updated.'
      redirect_to bus_stops_path
    else
      flash[:errors] = @stop.errors.full_messages
      redirect_to :back
    end
  end

  private

  def find_stop
    @stop = BusStop.find_by id: params.require(:id)
    unless @stop.present?
      render nothing: true, status: :not_found and return
    end
  end

  def stop_params
    # no attributes that people aren't supposed to be able to edit
    params.require(:bus_stop).permit!
  end
end
