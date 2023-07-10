class RenameBusStopNeedWork < ActiveRecord::Migration[7.0]
  def change
    rename_column :bus_stops, :need_work, :needs_work
  end
end
