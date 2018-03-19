class AddSignTypeToBusStops < ActiveRecord::Migration
  def change
    add_column :bus_stops, :sign_type, :string
  end
end
