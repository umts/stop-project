class AddUniqueIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index :bus_stops, :hastus_id, unique: true

    add_index :bus_stops_routes, %i[sequence route_id direction], unique: true
    add_index :bus_stops_routes, %i[bus_stop_id route_id direction], unique: true

    add_index :routes, :number, unique: true

    add_index :users, :name, unique: true
  end
end
