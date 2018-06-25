class AddDirectionToBusStopsRoutes < ActiveRecord::Migration[5.1]
  def change
    add_column :bus_stops_routes, :direction, :string
  end
end
