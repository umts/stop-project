class AddFullAttributesToBusStops < ActiveRecord::Migration[4.2]
  def change
    add_column :bus_stops, :accessible,         :string
    add_column :bus_stops, :bench,              :string
    add_column :bus_stops, :curb_cut,           :string
    add_column :bus_stops, :lighting,           :string
    add_column :bus_stops, :mounting,           :string
    add_column :bus_stops, :mounting_direction, :string
    add_column :bus_stops, :schedule_holder,    :string
    add_column :bus_stops, :shelter,            :string
    add_column :bus_stops, :sidewalk,           :string
    add_column :bus_stops, :sign,               :string
    add_column :bus_stops, :trash,              :string

    add_column :bus_stops, :bolt_on_base,        :boolean
    add_column :bus_stops, :bus_pull_out_exists, :boolean
    add_column :bus_stops, :extend_pole,         :boolean
    add_column :bus_stops, :has_power,           :boolean
    add_column :bus_stops, :new_anchor,          :boolean
    add_column :bus_stops, :new_pole,            :boolean
    add_column :bus_stops, :solar_lighting,      :boolean
    add_column :bus_stops, :straighten_pole,     :boolean
    add_column :bus_stops, :system_map_exists,   :boolean

    add_column :bus_stops, :mounting_clearance_after, :integer
    add_column :bus_stops, :mounting_clearance_before, :integer
  end
end
