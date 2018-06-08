class CreateBusStops < ActiveRecord::Migration[4.2]
  def change
    create_table :bus_stops do |t|
      t.string :name, null: false, default: ''
      t.integer :hastus_id, null: false
      t.boolean :has_post, null: false, default: false
      t.boolean :has_bench, null: false, default: false
      t.boolean :has_light, null: false, default: false
      t.boolean :has_ramp, null: false, default: false
      t.boolean :has_shelter, null: false, default: false
      t.boolean :has_trash, null: false, default: false
      t.boolean :has_sidewalk, null: false, default: false
    end
  end
end
