class AddIdToBusStopFields < ActiveRecord::Migration[5.1]
  def change
    add_column :bus_stop_fields, :id, :primary_key
  end
end
