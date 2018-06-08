class RemoveTestAttributesFromBusStops < ActiveRecord::Migration[4.2]
  def change
    remove_column :bus_stops, :has_post, :boolean
    remove_column :bus_stops, :has_bench, :boolean
    remove_column :bus_stops, :has_light, :boolean
    remove_column :bus_stops, :has_ramp, :boolean
    remove_column :bus_stops, :has_shelter, :boolean
    remove_column :bus_stops, :has_sidewalk, :boolean
    remove_column :bus_stops, :has_trash, :boolean
  end
end
