class UpdateColumnTypesAndName < ActiveRecord::Migration[5.1]
  def change
    rename_column :bus_stops, :shelter_ada_compliance, :shelter_ada_compliant
    remove_column :bus_stops, :has_power
    remove_column :bus_stops, :shared_sign_post
    remove_column :bus_stops, :system_map_exists
    remove_column :bus_stops, :trash
    add_column :bus_stops, :has_power, :string
    add_column :bus_stops, :shared_sign_post_frta, :boolean
    add_column :bus_stops, :system_map_exists, :string
    add_column :bus_stops, :trash, :boolean
  end
end
