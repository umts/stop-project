class CreateRoutes < ActiveRecord::Migration[5.1]
  def change
    create_table :routes do |t|
      t.string :number

      t.timestamps null: false
    end
    create_join_table :bus_stops, :routes
  end
end
