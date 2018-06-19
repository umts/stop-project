class BusStopsController < ApplicationController
  before_action :find_stop, only: %i[edit destroy id_search update]
  before_action :restrict_to_admin, only: %i[destroy manage]

  def autocomplete
    stops = BusStop.where 'lower(name) like ?',
                          "%#{params.require(:term)}%"
    render json: stops.pluck(:name).sort
  end

  def by_route
    @route = Route.find_by number: params.require(:number)
    if @route.present?
      @bus_stops = @route.bus_stops
      @completed_stops = @bus_stops.completed
      @incomplete_stops = @bus_stops.not_completed
      @stops = @incomplete_stops + @completed_stops
    else redirect_to bus_stops_path,
                     notice: "Route #{params[:number]} not found"
    end
  end

  def destroy
    @stop.destroy
    redirect_to manage_bus_stops_path,
      notice: "#{@stop.name} has been deleted."
  end

  def id_search
    redirect_to edit_bus_stop_path(@stop.hastus_id)
  end

  def manage
    @stops = BusStop.order(:name)
                    .paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.html { render :manage }
      format.csv do
        send_data @stops.to_csv,
          filename: "all-stops-#{Date.today.strftime('%Y%m%d')}.csv"
      end
    end
  end

  def name_search
    stop = BusStop.find_by name: params.require(:name)
    if stop.present?
      redirect_to edit_bus_stop_path(stop.hastus_id)
    else redirect_to bus_stops_path, 
                    notice: "Stop #{params[:name]} not found"
    end
  end

  def outdated
    @date = Date.parse(params[:date]) rescue 1.month.ago.to_date
    @stops = BusStop.not_updated_since(@date)
                    .order(:updated_at)
                    .paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.html { render :outdated }
      format.csv do
        send_data @stops.to_csv(limited_attributes: true),
          filename: "outdated-stops-since-#{@date.strftime('%Y%m%d')}.csv"
      end
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
      redirect_back(fallback_location: root_path,
        notice: "Stop #{params[:id]} not found") and return
    end
  end

  def stop_params
    # no attributes that people aren't supposed to be able to edit
    params.require(:bus_stop).permit!
  end
end
