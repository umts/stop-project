class AddSignTypeToBusStops < ActiveRecord::Migration[5.1]
  def change
    add_column :bus_stops, :sign_type, :string
  end
end
