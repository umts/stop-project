class CreateBusStopFields < ActiveRecord::Migration[5.1]
  def change
    create_table :bus_stop_fields do |t|
      t.string :value

      t.timestamps
    end
    create_join_table :bus_stops, :fields
  end
end
