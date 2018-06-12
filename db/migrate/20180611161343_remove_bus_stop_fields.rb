class RemoveBusStopFields < ActiveRecord::Migration[5.1]
  def change
    remove_column :bus_stops, :sign, :string
    remove_column :bus_stops, :extend_pole, :boolean
    remove_column :bus_stops, :new_anchor, :boolean
    remove_column :bus_stops, :new_pole, :boolean
    remove_column :bus_stops, :straighten_pole, :boolean
    remove_column :bus_stops, :mounting_clearance_after, :integer
    remove_column :bus_stops, :accessible, :string
  end
end
