class AddSignTypeToBusStops < ActiveRecord::Migration[4.2]
  def change
    add_column :bus_stops, :sign_type, :string
  end
end
