class CreateBusStopFields < ActiveRecord::Migration[5.1]
  def change
    create_table :bus_stop_fields do |t|
      t.string :value
      t.string :field_name
      t.integer :bus_stop_id

      t.timestamps
    end
  end
end
