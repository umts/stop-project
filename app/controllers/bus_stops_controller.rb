class BusStopsController < ApplicationController
  before_action :find_stop, except: %i(create index name_search)

  def create
    @stop = BusStop.new stop_params
    if @stop.save
      flash[:notice] = 'Bus stop was created.'
      redirect_to bus_stops_path
    else
      flash[:errors] = @stop.errors.full_messages
      render 'edit'
    end
  end

  def id_search
    render 'edit'
  end

  def index
    @stops = BusStop.all
  end
  
  def name_search
    @stop = BusStop.find_by name: params.require(:name)
    render 'edit'
  end

  def update
    @stop.assign_attributes stop_params
    if @stop.save
      flash[:notice] = 'Bus stop was updated.'
      redirect_to bus_stops_path
    else
      flash[:errors] = @stop.errors.full_messages
      render 'edit'
    end
  end

  private

  def find_stop
    @stop = BusStop.find_by hastus_id: params.require(:id)
    unless @stop.present?
      redirect_to :back, notice: 'Stop not found' and return
    end
  end

  def stop_params
    # no attributes that people aren't supposed to be able to edit
    params.require(:bus_stop).permit!
  end
end
