# frozen_string_literal: true

class BusStopsController < ApplicationController
  before_action :find_stop, only: %i[edit destroy update]
  before_action :restrict_to_admin, only: %i[destroy manage]
  before_action :set_fields_for_stop, only: %i[update edit]

  def autocomplete
    stops = BusStop.search_names(params.require(:term)).order(:name).limit(10)
    render partial: 'autocomplete', collection: stops, as: :stop
  end

  def by_sequence
    @route = Route.find_by number: params.require(:number)
    if @route.present?
      @stops = @route.bus_stops
      @collection = @route.bus_stops_routes.order(:direction, sequence: :asc).group_by(&:direction)
    else
      redirect_to bus_stops_path, notice: "Route #{params[:number]} not found"
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
    else
      redirect_to bus_stops_path, notice: "Route #{params[:number]} not found"
    end
  end

  def edit
    return if params[:route_id].blank?

    @route = Route.find(params[:route_id])
    @direction = params.require(:direction)
  end

  def update
    @stop.assign_attributes stop_params
    @stop.decide_if_completed_by current_user
    if @stop.save
      flash[:notice] = t('.success')
      if params[:commit] == 'Save and next' && params[:route_id]
        route_id = params[:route_id]
        next_stop = Route.find(route_id)
                         .next_stop_in_sequence(@stop, params[:direction])
        if next_stop
          redirect_to edit_bus_stop_path(id: next_stop.hastus_id, direction: params[:direction], route_id:)
        else
          route_number = Route.find(route_id).number
          redirect_to by_sequence_bus_stops_url(number: route_number)
        end
      else
        redirect_to bus_stops_path
      end
    else
      flash[:errors] = @stop.errors.full_messages
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @stop.destroy
    redirect_to manage_bus_stops_path, notice: t('.success', name: @stop.name)
  end

  def manage
    @stops = BusStop.order(:name).page(params[:page]).per(10)
    respond_to do |format|
      format.html { render :manage }
      format.csv do
        send_data BusStop.all.to_csv,
                  filename: "all-stops-#{Time.zone.today.strftime('%Y%m%d')}.csv"
      end
    end
  end

  def search
    stop = if params[:id].present?
             BusStop.find_by hastus_id: params[:id]
           elsif params[:name].present?
             BusStop.search_names(params[:name]).first
           end

    if stop.present?
      redirect_to edit_bus_stop_path(stop.hastus_id)
    else
      redirect_back fallback_location: bus_stops_path,
                    notice: t('.not_found', search: params[:id].presence || params[:name])
    end
  end

  def outdated
    @date = begin
      Date.parse(params[:date])
    rescue StandardError
      1.month.ago.to_date
    end
    @stops = BusStop.not_updated_since(@date).order(:updated_at)
    respond_to do |format|
      format.html do
        @stops = @stops.page(params[:page]).per(10)
        render :outdated
      end
      format.csv do
        send_data @stops.to_csv(limited_attributes: true),
                  filename: "outdated-stops-since-#{@date.strftime('%Y%m%d')}.csv"
      end
    end
  end

  def set_fields_for_stop
    @fields = BusStop::Options::COMBINED
    @fields.each_pair do |category, fields|
      fields.each_pair do |field, options|
        @fields[category][field] << @stop.send(field) if options.is_a?(Array) && options.exclude?(@stop.send(field))
      end
    end
  end

  private

  def find_stop
    @stop = BusStop.find_by hastus_id: params.require(:id)
    return if @stop.present?

    redirect_back fallback_location: root_path, notice: t('.not_found', search: params[:id])
  end

  def stop_params
    # no attributes that people aren't supposed to be able to edit
    params.require(:bus_stop).permit!
  end
end
