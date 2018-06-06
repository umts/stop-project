class CreateBusStopFields < ActiveRecord::Migration[5.1]
  def change
    create_table :bus_stop_fields do |t|
      t.integer :bus_stop_id
      t.string :field_name
      t.string :value

      t.timestamps
    end
  end
end
