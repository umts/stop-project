class BusStopsController < ApplicationController
  before_action :find_stop, only: %i[edit destroy id_search update]
  before_action :restrict_to_admin, only: %i[destroy manage]
  before_action :set_fields_for_stop, only: %i[update edit]

  def autocomplete
    stops = BusStop.where 'lower(name) like ?',
                          "%#{params.require(:term)}%"
    render json: stops.pluck(:name).sort
  end

  def by_sequence
    @route = Route.find_by number: params.require(:number)
    if @route.present?
      @stops = @route.bus_stops
      @collection = @route.bus_stops_routes.order(:direction, sequence: :asc).group_by(&:direction)
    else redirect_to bus_stops_path,
                     notice: "Route #{params[:number]} not found"
    end
  end

  def by_status
    @route = Route.find_by number: params.require(:number)
    if @route.present?
      @stops = @route.bus_stops.distinct
      @stops_hash = {}
      @stops_hash['Pending'] = @stops.pending
      @stops_hash['Not Started'] = @stops.not_started
      @stops_hash['Completed'] = @stops.completed
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
    @stops = BusStop.order(:name).paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.html { render :manage }
      format.csv do
        send_data BusStop.all.to_csv,
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
    @stops = BusStop.not_updated_since(@date).order(:updated_at)
    respond_to do |format|
      format.html do
        @stops = @stops.paginate(page: params[:page], per_page: 10)
        render :outdated
      end
      format.csv do
        send_data @stops.to_csv(limited_attributes: true),
                  filename: "outdated-stops-since-#{@date.strftime('%Y%m%d')}.csv"
      end
    end
  end

  def update
    @stop.assign_attributes stop_params
    @stop.decide_if_completed_by current_user
    if @stop.save
      flash[:notice] = 'Bus stop was updated.'
      if params[:commit] == 'Save and next' && params[:route_id]
        route_id = params[:route_id]
        next_stop = Route.find(route_id)
                         .next_stop_in_sequence(@stop, params[:direction])
        if next_stop
          redirect_to edit_bus_stop_path(id: bus_stop_route.bus_stop.hastus_id, direction: params[:direction], route_id: route_id)
        else
          route_number = Route.find(route_id).number
          redirect_to by_sequence_bus_stops_url(number: route_number)
        end
      else
        redirect_to bus_stops_path
      end
    else
      flash[:errors] = @stop.errors.full_messages
      render 'edit'
    end
  end

  def edit
    if params[:route_id]
      @route = Route.find(params[:route_id])
      @direction = params.require(:direction)
    end
  end

  def set_fields_for_stop
    @fields = BusStop::SUPER_HASH
    @fields.each_pair do |category, fields|
      fields.each_pair do |field, options|
        if options.is_a?(Array) && options.exclude?(@stop.send(field))
          @fields[category][field] << @stop.send(field)
        end
      end
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
