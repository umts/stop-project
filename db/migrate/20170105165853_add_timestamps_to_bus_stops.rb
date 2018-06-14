class AddTimestampsToBusStops < ActiveRecord::Migration[4.2]
  def change
    change_table :bus_stops do |t|
      t.timestamps null: false
      t.boolean :completed
      t.datetime :completed_at
    end
  end
end
