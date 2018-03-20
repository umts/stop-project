class BusStopsController < ApplicationController
  before_action :find_stop, only: %i[edit id_search update]
  before_action :restrict_to_admin, only: %i[manage]

  def autocomplete
    stops = BusStop.where 'lower(name) like ?',
                          "%#{params.require(:term)}%"
    render json: stops.pluck(:name)
  end

  def by_route
    @route = Route.find_by number: params.require(:number)
    if @route.present?
      @stops = @route.bus_stops
    else redirect_to bus_stops_path,
                     notice: "Route #{params[:number]} not found"
    end
  end

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
    redirect_to edit_bus_stop_path(@stop.hastus_id)
  end

  def manage
    @stops = BusStop.order(:name)
                    .paginate(page: params[:page], per_page: 10)
  end

  def name_search
    stop = BusStop.find_by name: params.require(:name)
    if stop.present?
      redirect_to edit_bus_stop_path(stop.hastus_id)
    else redirect_to bus_stops_path, 
                    notice: "Stop #{params[:name]} not found"
    end
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
      redirect_to :back, notice: "Stop #{params[:id]} not found" and return
    end
  end

  def stop_params
    # no attributes that people aren't supposed to be able to edit
    params.require(:bus_stop).permit!
  end
end
