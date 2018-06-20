class ChangeBooleansToStrings < ActiveRecord::Migration[5.1]
  def change
    change_column :bus_stops, :bolt_on_base, :string
    change_column :bus_stops, :bus_pull_out_exists, :string
    change_column :bus_stops, :has_power, :string
    change_column :bus_stops, :solar_lighting, :string
    change_column :bus_stops, :system_map_exists, :string
    change_column :bus_stops, :shelter_ada_compliance, :string
    change_column :bus_stops, :ada_landing_pad, :string
    change_column :bus_stops, :state_road, :string
    change_column :bus_stops, :accessible, :string
  end
end
