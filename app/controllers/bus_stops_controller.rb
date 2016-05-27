class BusStopsController < ApplicationController
  def index
    @stops = BusStop.all
  end
end
