class CreateBusStopsRoutes < ActiveRecord::Migration[5.1]
  def change
    add_column :bus_stops_routes, :sequence, :integer
  end
end
