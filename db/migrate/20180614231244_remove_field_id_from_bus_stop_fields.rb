class RemoveFieldIdFromBusStopFields < ActiveRecord::Migration[5.1]
  def change
    remove_column :bus_stop_fields, :field_id, :integer
  end
end
