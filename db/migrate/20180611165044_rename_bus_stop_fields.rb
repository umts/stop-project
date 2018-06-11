class RenameBusStopFields < ActiveRecord::Migration[5.1]
  def change
    rename_column :bus_stops, :sidewalk, :sidewalk_width
    rename_column :bus_stops, :mounting_clearance_before, :mounting_clearance
  end
end
