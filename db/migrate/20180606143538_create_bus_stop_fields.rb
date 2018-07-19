class CreateBusStopFields < ActiveRecord::Migration[5.1]
  def change
    create_join_table :bus_stops, :fields, table_name: :bus_stop_fields do |t|
      t.string :value

      t.timestamps
    end
  end
end
