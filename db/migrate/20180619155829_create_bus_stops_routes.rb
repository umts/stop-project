class CreateBusStopsRoutes < ActiveRecord::Migration[5.1]
  def change
    create_table :bus_stops_routes do |t|
      t.integer :sequence

      t.timestamps
    end
  end
end
