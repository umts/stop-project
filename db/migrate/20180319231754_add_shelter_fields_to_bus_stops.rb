class AddShelterFieldsToBusStops < ActiveRecord::Migration[4.2]
  def change
    add_column :bus_stops, :shelter_condition,     :string
    add_column :bus_stops, :shelter_pad_condition, :string
    add_column :bus_stops, :shelter_pad_material,  :string
    add_column :bus_stops, :shelter_type,          :string
  end
end
