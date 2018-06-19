class AddCompletedAtToBusStops < ActiveRecord::Migration[5.1]
  def change
    add_column :bus_stops, :completed_by, :integer
  end
end
