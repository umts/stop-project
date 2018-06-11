class RemoveBusStopFields < ActiveRecord::Migration[5.1]
  def change
    remove_column :bus_stops, :sign
    remove_column :bus_stops, :extend_pole
    remove_column :bus_stops, :new_anchor
    remove_column :bus_stops, :new_pole
    remove_column :bus_stops, :straighten_pole
    remove_column :bus_stops, :mounting_clearance_after
    remove_column :bus_stops, :completed_at
    remove_column :bus_stops, :accessible
  end
end
